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



# This recipe performs a dynamic DNS update using nsupdate (RFC 2136).
# Specifically, it adds a zone A record for this host in the supplied
# DNS server.  If used, it's meant to be used on every node in the realm,
# possibly alongside the customdns recipe.

# Requires the nsupdate program from the dnsutils package, but this 
# appears to be a system default package on Ubuntu.

include_recipe 'bind::tsigkey'

if node['bind']['discover_dns_server']
  bind = discover(:bind,:server)
  dns_server=bind.info['info']['addr']
  search_domain=bind.info['info']['search_domain'] ? bind.info['info']['search_domain'] : ""
  #search_domain=bind.info['info']['search_domain']
else
  dns_server = node['bind']['dns_server']
  search_domain = node['bind']['search_domain']
end

node_name=node['node_name'].gsub('_','-')
ttl=node['bind']['ttl']
public_ipv4=node['cloud']['public_ipv4']
local_ipv4=node['cloud']['local_ipv4']

Chef::Log.info("node_name=#{node_name}, ttl=#{ttl}")
Chef::Log.info("public_ipv4=#{public_ipv4}, local_ipv4=#{local_ipv4}")
Chef::Log.info("register_private_ip=#{node['bind']['register_private_ip']}")
ip_address = node['bind']['register_private_ip'] ? local_ipv4 : public_ipv4
keydir = `ls "#{node['bind']['sysconfdir']}"`
Chef::Log.info(keydir)
command = "(echo 'server #{dns_server}'; echo 'zone #{search_domain}'; echo 'update delete #{node_name}.#{search_domain} A'; echo 'update add #{node_name}.#{search_domain} #{ttl} A #{ip_address}'; echo 'send') | nsupdate -k #{node['bind']['sysconfdir']}/rndc.key"
Chef::Log.info "command is #{command}"

execute command do
  # Can fail if server is internal bind server that's not up yet,
  # We have to be okay with that
  ignore_failure true
end
