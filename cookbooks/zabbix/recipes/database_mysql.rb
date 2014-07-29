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

#
# == Setup ==
#
# Resources here are themselves idempotent.
#

#
# Installing Zabbix requires populating the database using schema &
# data files distributed with Zabbix.  I'd like to be able to do this
# without needing the MySQL command line client (`mysql`) but I
# haven't figured out a reasonable way yet.
#
# This recipe is usually run on the "Zabbix server" box so it's not
# unreasonable to want the MySQL command line client available anyway,
# for debugging purposes when logged in.
# 
include_recipe "mysql::client"
retries = 0
begin
  require 'mysql'
rescue Gem::LoadError, LoadError => e
  case node.platform
  when 'debian', 'ubuntu'
    package("libmysqlclient-dev") { action :nothing }.run_action(:install)
  when 'centos', 'redhat'
    package("mysql-devel") {action :nothing }.run_action(:install)
  end
  gem_package('mysql') { action :nothing }.run_action(:install)
  Gem.clear_paths
  require 'mysql'
  retries += 1
  if retries > 1
    Chef::Log.error("Could not install Ruby 'mysql' gem at compile time")
  else
    retry
  end
end

install_from_release('zabbix') do
  action        :configure
  release_url   node.zabbix.release_url
  version       node.zabbix.server.version
  not_if        { File.exist?(node.zabbix.home_dir) }
end

#
# == Installation ==
#
# If the configured MySQL database (`node[:zabbix][:database][:name]`)
# already exists, then none of the resources in this section should
# execute.
#
# Only if the database is missing will any of the following resources
# run.  In this case, the order will be
#
#   1) mysql_database[create_zabbix_database]
#   2) bash[load_zabbix_with_default_data]
#   3) mysql_database[remove_zabbix_default_hosts_and_templates] -- DISABLED FOR ZABBIX 2.0 PENDING FIX!
#   


#
# If the database is actually created, this resource will have changed
# state, and will fire notify the bash 'load_zabbix_with_default_data'
# to run.
# 
mysql_database "create_zabbix_database" do
  database_name node.zabbix.database.name
  connection    root_connection
  action        :create
  notifies      :run, "bash[load_zabbix_with_default_data]", :immediately
end

#
# This resource should *not* execute on every chef-client run so it is
# marked with action :nothing and notified to run by the
# 'create_zabbix_database' resource upon a change of state.
# 
bash "load_zabbix_with_default_data" do
  cwd      File.join(node.zabbix.home_dir, 'database', node.zabbix.database.install_method)
  code     "cat {schema,images,data}.sql | mysql -h #{root_connection[:host]} -u #{root_connection[:username]} --password=#{root_connection[:password]} #{node.zabbix.database.name}"
  action   :nothing

  # FIXME -- this query is broken in Zabbix 2.0 databases so we won't force it to run at the moment
  # notifies :query, "mysql_database[remove_zabbix_default_hosts_and_templates]", :immediately
end

#
# This resource should *not* run on every chef-client run.  It is
# triggered to run by the bash 'load_zabbix_with_default_data'
# resource, which populates the MySQL database with content, some of
# which we want to remove here.
#
# FIXME -- Zabbix 2.0 adds table constraints which make the blanket
# delete statement here not work.
# 
mysql_database "remove_zabbix_default_hosts_and_templates" do
  connection    root_connection
  database_name node.zabbix.database.name
  sql           'DELETE FROM hosts;' # maybe also delete default Actions?
  action        :nothing
end

#
# == Maintenance ==
#
# Resources in this section should execute on every chef-client run.
# Briefly:
#
#  1) Create/update the MySQL user used by Zabbix server and web
#     applications to connect to the MySQL database.
#
#  2) Create/update the default Zabbix admin user.  This not only
#     closes a security hole by changing the username and password of
#     the Zabbix admin user bundled with Zabbix, but also ensures a
#     Zabbix admin user with known credentials that can be used when
#     talking to the Zabbix API directly (through Rubix).
#

#
# Create/update the MySQL user that the Zabbix server and web
# application will login as.  We perform actions on every chef client
# run because, upon a re-cap in which the IP changed, we want to make
# sure that add MySQL GRANT statements for the new IP.
# 
host_user_connects_from = case node.zabbix.database.host
when 'localhost'; 'localhost';
#else ; node.
else ; node.ipaddress
end
mysql_database_user node.zabbix.database.user do
  connection    root_connection
  host          host_user_connects_from
  password      node.zabbix.database.password
  database_name node.zabbix.database.name
  privileges    [:select,:update,:insert,:create,:drop,:delete]
  action        [:create, :grant]
end

# Create/update the Zabbix admin user.  This closes a security hole by
# changing the default user's (`userid=1`) username & password, but
# also provides a Zabbix API user for other resources in this cookbook
# (`zabbix_host`, &c.) to utilize.
mysql_database "ensure_zabbix_api_user" do
  connection    root_connection
  database_name node.zabbix.database.name
  sql           <<SQL
    INSERT INTO `users` (
        `userid`,`alias`,`name`,`surname`,`passwd`,
        `url`,`autologin`,`autologout`,`lang`,`refresh`,`type`,`theme`,`rows_per_page`
      ) VALUES
      (
        '1','#{node.zabbix.api.username}','#{node.zabbix.api.first_name}','#{node.zabbix.api.last_name}','#{Digest::MD5.hexdigest(node.zabbix.api.password)}',
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
