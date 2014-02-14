#
# Cookbook Name::       zabbix
# Description::         Configures firewall access between Zabbix server & agents.
# Recipe::              firewall
# Author::              Nacer Laradji (<nacer.laradji@gmail.com>)
#
# Copyright 2011, Efactures
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

include_recipe 'ufw'
# enable platform default firewall
firewall "ufw" do
  action :enable
end

if node.zabbix.server.install == true
  # Search for some client
  zabbix_clients = search(:node ,'recipes:zabbix')

  zabbix_clients.each do |client|

    # Accept connection from zabbix_agent on server
    firewall_rule "zabbix_client_#{client[:fqdn]}" do
      port 10051
      protocol :udp
      source client[:ipaddress]
      action :allow
    end

  end if zabbix_clients

end

# Search for some client
zabbix_servers = search(:node ,'recipes:zabbix\:\:server')
if zabbix_servers
  zabbix_servers.each do |server|

    # Accept connection from zabbix_agent on server
    firewall_rule "zabbix_server_#{server[:fqdn]}" do
      port 10050
      protocol :udp
      source server[:ipaddress]
      action :allow
    end

  end if zabbix_servers
end


# enable platform default firewall
firewall "ufw" do
  action :enable
end
