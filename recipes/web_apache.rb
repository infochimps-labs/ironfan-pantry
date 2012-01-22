# Author:: Nacer Laradji (<nacer.laradji@gmail.com>)
# Cookbook Name:: zabbix
# Recipe:: web_apache
#
# Copyright 2011, Efactures
#
# Apache 2.0
#

# Execute apache2 receipe + mod_php5 receipe
include_recipe "apache2"
include_recipe "apache2::mod_php5"

if node[:zabbix][:web][:fqdn] != nil
  #install vhost for zabbix frontend
  web_app "#{node.zabbix.web.fqdn}" do
    server_name node.zabbix.web.fqdn
    server_aliases "zabbix"
    docroot "/opt/zabbix/web"
  end  
end
