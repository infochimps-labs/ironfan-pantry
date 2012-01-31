#
# Cookbook Name::       zabbix
# Description::         Configures Zabbix MySQL database.
# Recipe::              database_mysql
# Author::              Nacer Laradji (<nacer.laradji@gmail.com>)
#
# Copyright 2011, Efactures
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

include_recipe "mysql::client"

# Establish root MySQL connection
root_mysql_conn = {:host => node.zabbix.database.host, :username => node.zabbix.database.root_user, :password => node.zabbix.database.root_password}

# Ensure we have the mysql gem available at *compile* time.
begin
  require 'mysql'
rescue LoadError
  case node[:platform]
  when 'ubuntu', 'debian'
    package("libmysqlclient16-dev") {action :nothing }.run_action(:install)
  else
    Chef::Log.warn "No native MySQL client support for OS #{node[:platform]}"
  end
  gem_package("mysql") { action :nothing }.run_action(:install)
  Gem.clear_paths  
  require 'mysql'
end

# Only execute if database is missing...
m=Mysql.new(node.zabbix.database.host,node.zabbix.database.root_user,node.zabbix.database.root_password)
if m.list_dbs.include?(node.zabbix.database.name) == false

  # Create Zabbix database
  mysql_database node.zabbix.database.name do
    connection root_mysql_conn
    action     :create
    notifies   :run,    "execute[zabbix_populate_schema]"
    notifies   :run,    "execute[zabbix_populate_data]"
    notifies   :run,    "execute[zabbix_populate_image]"
    notifies   :create, "template[/etc/zabbix/zabbix_server.conf]"
  end

  # Create Zabbix database user
  mysql_database_user node.zabbix.database.user do
    connection root_mysql_conn
    password   node.zabbix.database.password
    action     :create
  end
  
  # Populate Zabbix database
  populate_command = "/usr/bin/mysql -h #{node.zabbix.database.host} -u #{node.zabbix.database.root_user} #{node.zabbix.database.name} -p#{node.zabbix.database.root_password} < /opt/zabbix-#{node.zabbix.server.version}"
  execute "zabbix_populate_schema" do
    command "#{populate_command}/create/schema/mysql.sql"
    action :nothing
  end
  execute "zabbix_populate_data" do
    command "#{populate_command}/create/data/data.sql"
    action :nothing
  end
  execute "zabbix_populate_image" do
    command "#{populate_command}/create/data/images_mysql.sql"
    action :nothing
  end

  # Grant Zabbix user to connect from *this* node
  mysql_database_user node.zabbix.database.user do
    connection    root_mysql_conn
    password      node.zabbix.database.password
    host          node.fqdn     # connections only allowed from *this* node
    database_name node.zabbix.database.name
    privileges    [:select,:update,:insert,:create,:drop,:delete]
    action        :grant
  end
end
