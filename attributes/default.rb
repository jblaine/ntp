#
# Cookbook Name:: ntp
# Attributes:: default
#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Tim Smith (<tsmith@limelight.com>)
# Author:: Charles Johnson (<charles@opscode.com>)
#
# Copyright 2009-2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# default attributes for all platforms
default['ntp']['servers']      = []
default['ntp']['peers']        = []
default['ntp']['restrictions'] = []
default['ntp']['base_restrictions'] = [
  'default kod notrap nomodify nopeer noquery',
  '127.0.0.1 nomodify',
  '-6 default kod notrap nomodify nopeer noquery',
  '-6 ::1 nomodify'
]
default['ntp']['servers']      = [
  '0.pool.ntp.org',
  '1.pool.ntp.org',
  '2.pool.ntp.org',
  '3.pool.ntp.org'
]
default['ntp']['server_flags'] = 'iburst'
default['ntp']['peer_flags'] = 'iburst'

# internal attributes
default['ntp']['packages'] = %w(ntp ntpdate)
default['ntp']['service'] = 'ntpd'
default['ntp']['varlibdir'] = '/var/lib/ntp'
default['ntp']['driftfile'] = "#{node['ntp']['varlibdir']}/ntp.drift"
default['ntp']['conffile'] = '/etc/ntp.conf'
default['ntp']['statsdir'] = '/var/log/ntpstats/'
default['ntp']['conf_owner'] = 'root'
default['ntp']['conf_group'] = 'root'
default['ntp']['var_owner'] = 'ntp'
default['ntp']['var_group'] = 'ntp'
default['ntp']['leapfile'] = '/etc/ntp.leapseconds'
default['ntp']['sync_clock'] = false
default['ntp']['sync_hw_clock'] = false

# overrides on a platform-by-platform basis
case node['platform_family']
when 'debian'
  default['ntp']['service'] = 'ntp'
when 'rhel'
  default['ntp']['packages'] = %w(ntp) if node['platform_version'].to_i < 6
when 'windows'
  default['ntp']['service'] = 'NTP'
  default['ntp']['driftfile'] = 'C:\\NTP\\ntp.drift'
  default['ntp']['conffile'] = 'C:\\NTP\\etc\\ntp.conf'
  default['ntp']['conf_owner'] = 'Administrators'
  default['ntp']['conf_group'] = 'Administrators'
  default['ntp']['package_url'] = 'http://www.meinbergglobal.com/download/ntp/windows/ntp-4.2.6p5@london-o-lpv-win32-setup.exe'
  default['ntp']['vs_runtime_url'] = 'http://download.microsoft.com/download/1/1/1/1116b75a-9ec3-481a-a3c8-1777b5381140/vcredist_x86.exe'
  default['ntp']['vs_runtime_productname'] = 'Microsoft Visual C++ 2008 Redistributable - x86 9.0.21022'
when 'freebsd'
  default['ntp']['packages'] = %w(ntp)
  default['ntp']['varlibdir'] = '/var/db'
  default['ntp']['driftfile'] = "#{node['ntp']['varlibdir']}/ntpd.drift"
  default['ntp']['statsdir'] = "#{node['ntp']['varlibdir']}/ntpstats"
  default['ntp']['conf_group'] = 'wheel'
  default['ntp']['var_group'] = 'wheel'
when 'solaris2'
  # This cookbook has no support for Solaris package ops.
  # Install SUNWntpr and SUNWntpu on your own somehow.
  default['ntp']['packages'] = []
  default['ntp']['service'] = 'ntp'
  default['ntp']['conffile'] = '/etc/inet/ntp.conf'
  if node['platform_version'].to_f <= 5.10
    default['ntp']['server_flags'] = ''
    default['ntp']['peer_flags'] = ''
    # Across SunOS 5.10 and earlier due to ntpd 3.x :|
    default['ntp']['base_restrictions'] = [
      'default notrap nomodify nopeer noquery',
      '127.0.0.1 nomodify'
    ]
  end
end
