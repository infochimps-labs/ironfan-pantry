# Author:: Dhruv Bansal (<dhruv.bansal@infochimps.com>)
# Cookbook Name:: zabbix
# Recipe:: server
#
# Copyright 2012, Infochimps
#
# Apache 2.0
#

directory node.zabbix.server.log_dir do
  owner 'zabbix'
  group 'zabbix'
  mode '0755'
end

include_recipe "zabbix::server_#{node.zabbix.server.install_method}"
include_recipe "zabbix::server_sends_email"
include_recipe "zabbix::server_sends_texts"

announce(:zabbix, :server,
         :logs =>  { :server => node.zabbix.server.log_dir },
         :ports => {
           :server => {
             :port   => 10050,
             :ignore => true
           }
         },
         :daemons => { :server => 'zabbix_server' }
         )
