# Author:: Dhruv Bansal (<dhruv@infochimps.com>)
# Cookbook Name:: zabbix
# Recipe:: web_nginx
#
# Copyright 2012, Infochimps
#
# Apache 2.0
#

template "/etc/zabbix/php.ini" do
  source 'php.ini.erb'
  owner 'www-data'
  action :create
  notifies :restart, 'service[zabbix_web]', :delayed
end

template "/etc/nginx/sites-available/zabbix.conf" do
  source 'zabbix_web.nginx.conf.erb'
  action :create
  notifies :restart, 'service[nginx]', :delayed
end

nginx_site 'zabbix.conf' do
  action :enable
end

runit_service "zabbix_web"

announce(:zabbix, :web,
         :logs    => { :app => node.zabbix.web.log_dir, :sv => '/etc/sv/zabbix_web/log/main/current' },
         :ports   => {
           :app => {
             :port    => node.zabbix.web.port,
             :service => 'http'
           }
         },
         :daemons => { :php => 'zabbix_web' }
         )
