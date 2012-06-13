#
# Cookbook Name::       zabbix
# Description::         Configures PHP-driven, reverse-proxied Zabbix web frontend.
# Recipe::              web
# Author::              Dhruv Bansal (dhruv@infochimps.com)
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

case node[:platform]
when "ubuntu","debian"
  bash "apt-get-y-update" do
    code "apt-get -y update"
  end
  %w[traceroute php5-cgi php5-mysql php5-gd].each { |name| package(name) }
when "centos"
  %w[traceroute php php-mysql php-gd php-bcmath php-mbstring php-xml].each { |name| package(name) }
else
  log "No #{node.platform} support yet"
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

[node.zabbix.web.log_dir, "/opt/zabbix-#{node.zabbix.server.version}/frontends/php/conf"].each do |d|
  directory d do
    owner 'www-data'
    group 'www-data'
    mode '0755'
    action :create
    recursive true
  end
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
