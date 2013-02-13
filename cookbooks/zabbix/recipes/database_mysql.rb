#
# Cookbook Name::       zabbix
# Description::         Configures Zabbix MySQL database.
# Recipe::              database_mysql
# Author::              Dhruv Bansal (<dhruv@infochimps.com>), Nacer Laradji (<nacer.laradji@gmail.com>)
#
# Copyright 2012-2013, Infochimps
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

# Shared connection information for connecting to the MySQL database.
root_connection = {
  host:     node.zabbix.database.host,
  username: node.zabbix.database.root_user,
  password: node.zabbix.database.root_password
}

# I'd really like to be able to implement loading data from files on
# disk into MySQL without having to install and use the mysql command
# line client...but haven't figured that out yet.  So we include the
# mysql::client recipe to ensure that, by the time we get to these
# resources at converge time, mysql is available on the command-line.
#
# This resource should *not* execute on every chef-client run so it is
# marked with action :nothing and notified to run by the next resource
# upon a change of state.  This resource, in turn, notifies the
# resource which cleans these newly populating contents of cruft we
# don't want.
include_recipe "mysql::client"
bash "load_zabbix_with_default_data" do
  cwd      File.join(node.zabbix.home_dir, 'database', node.zabbix.database.install_method)
  code     "cat {schema,images,data}.sql | mysql -h #{root_connection[:host]} -u #{root_connection[:username]} --password=#{root_connection[:password]} #{node.zabbix.database.name}"
  action   :nothing

  # FIXME -- this query is broken in Zabbix 2.0 databases so we won't force it to run at the moment
  # notifies :query, "mysql_database[remove_zabbix_default_hosts_and_templates]", :immediately
end

# If the database is actually created, this resource will have changed
# state, and will fire notify the bash 'load_zabbix_with_default_data'
# to run.
mysql_database node.zabbix.database.name do
  connection root_connection
  action     :create
  notifies   :run, "bash[load_zabbix_with_default_data]", :immediately
end

# This resource should *not* run on every chef-client run.  It is
# triggered to run by the bash 'load_zabbix_with_default_data'
# resource, which populates the MySQL database with content, some of
# which we want to remove here.
#
# FIXME -- There are some constraints built into the hosts table that
# make it difficult to wantonly delete all hosts.  Have to be more
# careful here...
mysql_database "remove_zabbix_default_hosts_and_templates" do
  connection    root_connection
  database_name node.zabbix.database.name
  sql           'DELETE FROM hosts;' # maybe also delete default Actions?
  action        :nothing
end

# Now we can create the MySQL user that the Zabbix server and web
# application will login as.  We perform actions on every chef client
# run because, upon a re-cap in which the IP changed, we want to make
# sure that add MySQL GRANT statements for the new IP.
host_user_connects_from = case node.zabbix.database.host
when 'localhost'; 'localhost';
else ; node.fqdn
end
mysql_database_user node.zabbix.database.user do
  connection    root_connection
  host          host_user_connects_from
  password      node.zabbix.database.password
  database_name node.zabbix.database.name
  privileges    [:select,:update,:insert,:create,:drop,:delete]
  action        [:create, :grant]
end

# We create the Zabbix admin user (a row in the Zabbix MySQL database,
# as compared to a MySQL user, which is a row in the
# information_schema database...).
mysql_database "ensure_zabbix_api_user" do
  connection    root_connection
  database_name node.zabbix.database.name
  sql           <<SQL
    INSERT INTO `users` (
        `userid`,`alias`,`name`,`surname`,`passwd`,
        `url`,`autologin`,`autologout`,`lang`,`refresh`,`type`,`theme`,`rows_per_page`
      ) VALUES
      (
        '#{node.zabbix.api.userid}','#{node.zabbix.api.username}','#{node.zabbix.api.first_name}','#{node.zabbix.api.last_name}','#{Digest::MD5.hexdigest(node.zabbix.api.password)}',
        '#{node.zabbix.api.url}','#{node.zabbix.api.autologin}','#{node.zabbix.api.autologout}','#{node.zabbix.api.lang}','#{node.zabbix.api.refresh}','#{node.zabbix.api.type}','#{node.zabbix.api.theme}','#{node.zabbix.api.rows}'
      ) ON DUPLICATE KEY UPDATE
        `alias`='#{node.zabbix.api.username}',
        `name`='#{node.zabbix.api.first_name}',
        `surname`='#{node.zabbix.api.last_name}',
        `passwd`='#{Digest::MD5.hexdigest(node.zabbix.api.password)}',
        `url`='#{node.zabbix.api.url}',
        `autologin`='#{node.zabbix.api.autologin}',
        `autologout`='#{node.zabbix.api.autologout}',
        `lang`='#{node.zabbix.api.lang}',
        `refresh`='#{node.zabbix.api.refresh}',
        `type`='#{node.zabbix.api.type}',
        `theme`='#{node.zabbix.api.theme}',
        `rows_per_page`='#{node.zabbix.api.rows}';
SQL
  action        :query
end
