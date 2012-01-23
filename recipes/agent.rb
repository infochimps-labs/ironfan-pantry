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

announce(:zabbix, :agent,
         :logs  => { :agent => node.zabbix.agent.log_dir },
         :ports => { :agent => {
             :port   => 10051,
             :ignore => true
           }
         },
         :daemons => { :agent => 'zabbix_agentd' }
         )
