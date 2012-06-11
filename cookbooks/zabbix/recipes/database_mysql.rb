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

include_recipe 'mysql::client'

# Establish root MySQL connection
root_mysql_conn    = {:host => node.zabbix.database.host, :username => node.zabbix.database.root_user, :password => node.zabbix.database.root_password}
base_mysql_command = "/usr/bin/mysql -h #{node.zabbix.database.host} -u #{node.zabbix.database.root_user} #{node.zabbix.database.name} -p#{node.zabbix.database.root_password}"

# Ensure we have the mysql gem available at *compile* time.
begin
  require 'mysql'
rescue LoadError
  case node[:platform]
  when 'ubuntu', 'debian'
    package("libmysqlclient16-dev") {action :nothing }.run_action(:install)
  when 'centos'
    package("mysql-devel") {action :nothing }.run_action(:install)
  else
    Chef::Log.warn "No native MySQL client support for OS #{node[:platform]}"
  end
  gem_package("mysql") { action :nothing }.run_action(:install)
  Gem.clear_paths
  require 'mysql'
end

# Only execute if database is missing...
mysql_connection = Mysql.new(node.zabbix.database.host,node.zabbix.database.root_user,node.zabbix.database.root_password)
if mysql_connection.list_dbs.include?(node.zabbix.database.name) == false

  # Create Zabbix database
  mysql_database node.zabbix.database.name do
    connection root_mysql_conn
    action     :create
    notifies   :run,    "execute[zabbix_populate_schema]",          :immediately
    notifies   :run,    "execute[zabbix_populate_data]",            :immediately
    notifies   :run,    "execute[zabbix_populate_image]",           :immediately
    notifies   :create, "template[/etc/zabbix/zabbix_server.conf]", :immediately
  end

  # Create Zabbix database user
  mysql_database_user node.zabbix.database.user do
    connection root_mysql_conn
    password   node.zabbix.database.password
    action     :create
  end

  # Populate Zabbix database
  populate_command = "#{base_mysql_command} < /opt/zabbix-#{node.zabbix.server.version}"
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
end

# Grant Zabbix user to connect from *this* node.  We do this even if
# the database already exists to handle the situation in which this
# node's IP changes (e.g. - during stop/start).
mysql_client_address = case node.zabbix.database.host
  when 'localhost'; 'localhost';
  else ; node.fqdn
end
mysql_database_user node.zabbix.database.user do
  connection    root_mysql_conn
  password      node.zabbix.database.password
  host          mysql_client_address     # connections only allowed from *this* node
  database_name node.zabbix.database.name
  privileges    [:select,:update,:insert,:create,:drop,:delete]
  action        :grant
end

# Create a Zabbix "Admin" user, an "API access" group, and ensure the
# super user is in the API access group.  This lets us
ruby_block "zabbix_ensure_super_admin_user_with_api_access" do
  block do
    username   = node.zabbix.api.username
    first_name = 'Zabbix'
    last_name  = 'Administrator'
    md5        = Digest::MD5.hexdigest(node.zabbix.api.password)
    rows       = 200
    type       = 3
    grp_name   = node.zabbix.api.user_group
    api_access = 1

    mysql_connection.query(%Q{USE #{node.zabbix.database.name}})

    existing_users = mysql_connection.query(%Q{SELECT userid FROM users WHERE `alias`="#{username}"})
    if existing_users.num_rows == 0
      mysql_connection.query(%Q{INSERT INTO users (alias, name, surname, passwd, rows_per_page, type) VALUES ("#{username}", "#{first_name}", "#{last_name}", "#{md5}", #{rows}, #{type})})
      userid = mysql_connection.query(%Q{SELECT userid FROM users WHERE `alias`="#{username}"}).fetch_row.first.to_i
    else
      userid = existing_users.fetch_row.first.to_i
      mysql_connection.query(%Q{UPDATE users SET `alias`="#{username}", name="#{first_name}", surname="#{last_name}", passwd="#{md5}", rows_per_page=#{rows}, type=#{type} WHERE userid="#{userid}"})
    end

    existing_groups = mysql_connection.query(%Q{SELECT usrgrpid FROM usrgrp WHERE name="#{grp_name}"})
    if existing_groups.num_rows == 0
      mysql_connection.query(%Q{INSERT INTO usrgrp (name, api_access) VALUES ("#{grp_name}", #{api_access})})
      usrgrpid = mysql_connection.query(%Q{SELECT usrgrpid FROM usrgrp WHERE name="#{grp_name}"}).fetch_row.first.to_i
    else
      usrgrpid = existing_groups.fetch_row.first.to_i
      mysql_connection.query(%Q{UPDATE usrgrp SET name="#{grp_name}", api_access=#{api_access} WHERE usrgrpid=#{usrgrpid}})
    end

    existing_join = mysql_connection.query(%Q{SELECT id FROM users_groups WHERE usrgrpid=#{usrgrpid} AND userid=#{userid}})
    if existing_join.num_rows == 0
      mysql_connection.query(%Q{INSERT INTO users_groups (usrgrpid, userid) VALUES (#{usrgrpid}, #{userid})})
    end

    mysql_connection.query(%Q{DELETE FROM users WHERE alias='admin'});
  end
  notifies :restart, "service[zabbix_server]"
end
