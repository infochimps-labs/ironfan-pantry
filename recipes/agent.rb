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

include_recipe "zabbix::agent_#{node.zabbix.agent.install_method}"

# We can create a host in Zabbix corresponding to this agent.
if node.zabbix.agent.create_host

  zabbix_server_ip = default_zabbix_server_ip

  node_host_groups = ((node.zabbix.host_groups || []) rescue []).to_set
  node_templates   = ((node.zabbix.templates   || []) rescue []).to_set

  node_host_groups << 'All Nodes'
  node_host_groups << node.cluster_name
  node_host_groups << [node.cluster_name, node.facet_name].join('-')

  node_templates << 'Template_Node'

  zabbix_host node[:node_name] do
    server      zabbix_server_ip
    host_groups node_host_groups.to_a
    templates   node_templates.to_a
  end
end

announce(:zabbix, :agent,
         :realm => discovery_realm(:zabbix, :server),
         :logs  => { :agent => node.zabbix.agent.log_dir },
         :ports => { :agent => {
             :port   => 10051,
             :ignore => true
           }
         },
         :daemons => { :agent => 'zabbix_agentd' }
         )
