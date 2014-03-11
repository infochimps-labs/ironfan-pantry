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
# This recipe uses the Debian resolvconf system, and is only expected
# to work on Debian-derived distributions.

# If you're using the customdns recipe to forward DNS requests to a
# bind server configured with the 'server' recipe, be careful not to
# run the 'customdns' recipe on the 'server' node, or bind will 
# forward queries to itself.

if node['bind']['discover_dns_server']
  bind = discover(:bind,:server)
  dns_server=bind.info['info']['addr']
  search_domain=bind.info['info']['search_domain']
else
  dns_server = node['bind']['dns_server']
  search_domain = node['bind']['search_domain']
end

template '/etc/default/customdns' do
  source 'customdns.default.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables(
    :dns_server => dns_server,
    :search_domain => search_domain
  )
end

template '/etc/init.d/customdns' do
  owner 'root'
  group 'root'
  mode 0755
end

service 'customdns' do
  supports :reload => false, :status => true
  action [ :enable, :restart ]
end

