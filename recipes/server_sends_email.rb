# Author:: Dhruv Bansal (<dhruv@infochimps.com>)
# Cookbook Name:: zabbix
# Recipe:: server_sends_email
#
# Copyright 2012, Infochimps
#
# Apache 2.0
#
# http://conoroneill.net/monitoring-ec2-servers-with-zabbix

%w[sendEmail libio-socket-ssl-perl libnet-ssleay-perl].each { |name| package(name) }

%w[from server port username password].each do |prop|
  value = node.zabbix.smtp.send(prop)
  Chef::Log.warn("node[:zabbix][:smtp][:#{prop}] is blank; Zabbix server will not be able to send email.") if value.nil? || value.empty?
end
  
template "/opt/zabbix/AlertScriptsPath/zabbix_sendemail" do
  source 'zabbix_sendemail.erb'
  owner 'zabbix'
  group 'admin'
  mode 0770
  action :create
end
