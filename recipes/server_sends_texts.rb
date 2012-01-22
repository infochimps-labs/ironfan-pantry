# Author:: Dhruv Bansal (<dhruv@infochimps.com>)
# Cookbook Name:: zabbix
# Recipe:: server_sends_texts
#
# Copyright 2012, Infochimps
#
# Apache 2.0
#
# http://conoroneill.net/monitoring-ec2-servers-with-zabbix

%w[id token phone].each do |prop|
  value = node.zabbix.twilio.send(prop)
  Chef::Log.warn("node[:zabbix][:twilio][:#{prop}] is blank; Zabbix server will not be able to send texts.") if value.nil? || value.empty?
end
template "/opt/zabbix/AlertScriptsPath/zabbix_sendtext" do
  source 'zabbix_sendtext.erb'
  owner 'zabbix'
  group 'admin'
  mode 0770
  action :create
end
