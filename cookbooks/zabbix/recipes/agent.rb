#
# Cookbook Name::       zabbix
# Description::         Installs and launches Zabbix agent.
# Recipe::              agent
# Author::              Dhruv Bansal (<dhruv@infochimps.com>)
#
# Copyright 2012, Infochimps
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

directory node.zabbix.agent.log_dir do
  owner 'zabbix'
  group 'zabbix'
  mode '0755'
end

server_ips = all_zabbix_server_ips()
# Install configuration
template "/etc/zabbix/zabbix_agentd.conf" do
  source "zabbix_agentd.conf.erb"
  owner "root"
  group "root"
  mode "644"
  notifies :restart, "service[zabbix_agentd]", :delayed
  variables :server_ips => server_ips
end

# Install Init script
template "/etc/init.d/zabbix_agentd" do
  source "zabbix_agentd.init.erb"
  owner "root"
  group "root"
  mode "754"
end

include_recipe "zabbix::agent_#{node.zabbix.agent.install_method}"

# We can create a host in Zabbix corresponding to this agent.
if node.zabbix.agent.create_host
  zabbix_server_ip = default_zabbix_server_ip
  node_host_groups = node_zabbix_host_groups
  node_templates   = node_zabbix_templates
  zabbix_host node[:node_name] do
    server      zabbix_server_ip
    host_groups node_host_groups
    templates   node_templates
    monitored   true
  end
end

if node.zabbix.agent.unmonitor_on_shutdown
  template "/etc/zabbix/externalscripts/unmonitor_zabbix_host.rb" do
    source    "unmonitor_zabbix_host.rb.erb"
    mode      '0776'
    variables :ip => zabbix_server_ip
    action    :create
  end
  
  template "/etc/init/unmonitor_zabbix_host.conf" do
    source 'unmonitor_zabbix_host.conf.erb'
    action :create
  end
end

link "/usr/local/bin/zabbix_sender" do
  to "/opt/zabbix/bin/zabbix_sender"
end

announce(:zabbix, :agent,
         # register in the same realm, for discovery purposes
         :realm => discovery_realm(:zabbix, :server), 
         :logs  => { :agent => node.zabbix.agent.log_dir },
         :ports => { :agent => {
             :port    => 10051,
             :monitor => false
           }
         },
         :daemons => { :agent => 'zabbix_agentd' }
         )
