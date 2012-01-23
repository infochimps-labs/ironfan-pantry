# Author:: Dhruv Bansal (dhruv@infochimps.com)
# Cookbook Name:: zabbix
# Recipe:: web
#
# Copyright 2012, Infochimps
#
# Apache 2.0
#

case node[:platform]
when "ubuntu","debian"
  %w[traceroute php5-cgi php5-mysql php5-gd].each { |name| package(name) }
when "centos"
  log "No centos Support yet"
end

# Link to the web interface version
link "/opt/zabbix/web" do
  to "/opt/zabbix-#{node.zabbix.server.version}/frontends/php"
end

# fix web folder right
script "zabbix_fix_web_right" do
  interpreter "bash"
  user "root"
  cwd "/opt"
  action :nothing
  code <<-EOH
  chown www-data -R /opt/zabbix-#{node.zabbix.server.version}/frontends/php
  EOH
end

# Give access to www-data to zabbix frontend config folder
directory "/opt/zabbix-#{node.zabbix.server.version}/frontends/php" do
  owner "www-data"
  group "www-data"
  mode "0755"
  recursive true
  action :create
  notifies :run, resources(:script => "zabbix_fix_web_right")
end

directory node.zabbix.web.log_dir do
  owner 'www-data'
  group 'www-data'
  mode '0755'
  action :create
  recursive true
end

template "/opt/zabbix-#{node.zabbix.server.version}/frontends/php/conf/zabbix.conf.php" do
  source "zabbix.conf.php.erb"
  owner 'www-data'
  group 'www-data'
  mode '0600'
  action :create
end

# Configure upstream webserver.
include_recipe "zabbix::web_#{node.zabbix.web.install_method}"
