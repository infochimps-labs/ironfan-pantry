# Author:: Dhruv Bansal (<dhruv@infochimps.com>)
# Cookbook Name:: zabbix
# Recipe:: agent
#
# Copyright 2012, Infochimps
#
# Apache 2.0
#

directory node.zabbix.agent.log_dir do
  owner 'zabbix'
  group 'zabbix'
  mode '0755'
end
  
include_recipe "zabbix::agent_#{node.zabbix.agent.install_method}"

# We can create a host in Zabbix corresponding to this agent.
if node.zabbix.agent.create_host

  connect_to_zabbix_api!

  node_host_groups = (node.zabbix.host_groups || []).to_set
  node_templates   = (node.zabbix.templates   || []).to_set

  node_host_groups << node.cluster_name
  node_host_groups << [node.cluster_name, node.facet_name].join('-')

  node_templates << 'Template_Node'
  
  zabbix_host node[:node_name] do
    host_groups node_host_groups.to_a
    templates   node_templates.to_a
  end
end




announce(:zabbix, :agent,
         :logs  => { :agent => node.zabbix.agent.log_dir },
         :ports => { :agent => {
             :port   => 10051,
             :ignore => true
           }
         },
         :daemons => { :agent => 'zabbix_agentd' }
         )
