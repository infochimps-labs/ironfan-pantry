# Copyright 2014, Infochimps, a CSC company
# Author: Erik Mackdanz
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


# This recipe installs an init script called customdns.  The script
# configures basic DNS settings which override the DNS provided by DHCP.

# If you're using the customdns recipe to forward DNS requests to a
# bind server configured with the 'server' recipe, be careful not to
# run the 'customdns' recipe on the 'server' node, or bind will 
# forward queries to itself.

if node['bind']['discover_dns_server']
  bind = discover(:bind,:server)
  dns_server=bind.info['info']['addr']
  search_domain=bind.info['info']['search_domain'] ? bind.info['info']['search_domain'] : ""
else
  dns_server = node['bind']['dns_server']
  search_domain = node['bind']['search_domain']
end

old_dns = ''
resolv = File.readlines('/etc/resolv.conf').map{ |line| line.chomp }
# This will return the last nameserver entry in the file
resolv.each do |entry|
  if entry =~ /nameserver (\S+)/
    old_dns = $1
  end
end

Chef::Log.info("Variables #{dns_server}, #{search_domain}, #{old_dns}")
template '/etc/default/customdns' do
  source 'customdns.default.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables(
    :dns_server => dns_server,
    :search_domain => search_domain,
    :old_dns => old_dns
  )
end

cookbook_file '/etc/dhclient-enter-hooks' do
  owner 'root'
  group 'root'
  mode 0755
  only_if { platform_family?('rhel') }
end

template '/etc/init.d/customdns' do
  if platform_family?('rhel')
    source 'customdns.rhel.erb'
  elsif platform_family?('debian')
    source 'customdns.erb'
  end
  owner 'root'
  group 'root'
  mode 0755
end

service 'customdns' do
  supports :reload => false, :status => true
  action [ :enable, :restart ]
end

