#
# Cookbook Name::       hadoop_hive
# Description::         Configures Hive MySQL database.
# Recipe::              hive_mysql_setup
# Author::              Josh Bronson (<josh@infochimps.com>)
#
# Copyright 2013, Infochimps
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

#--------------------------------------------------------------------------------
# dependencies and compile-time tools
#--------------------------------------------------------------------------------

include_recipe "mysql::client"

# We *connect* as the root user but will create the hive user later.
mysql_connection_info = {
  host:     node[:hive][:mysql][:host],
  port:     node[:hive][:mysql][:port],
  username: node[:hive][:mysql][:root_username],
  password: node[:hive][:mysql][:root_password],
}

hive_database = node[:hive][:mysql][:database]

mysql_database hive_database  do
  connection mysql_connection_info
  action     :create
end

script_relative_path = node[:hive][:mysql][:upgrade_script].sub(':version:', node[:hive][:version])
script_absolute_path = File.join(node[:hive][:home_dir], script_relative_path)
mysql_statements = [
                    "USE #{hive_database}",
                    "SOURCE #{script_absolute_path}",
].join(";")
execute "Run metastore update script" do
  params = {}
  params['-h'] = mysql_connection_info[:host]
  params['-P'] = mysql_connection_info[:port]
  params['-u'] = mysql_connection_info[:username]
  params['-p'] = mysql_connection_info[:password] unless mysql_connection_info[:password].nil?
  params['-e'] = "\"SOURCE #{script_absolute_path}\""
  params['-D'] = hive_database

  command "/usr/bin/mysql " + params.flatten.join(" ")
end

hive_user = node[:hive][:mysql][:username]
hive_pass = node[:hive][:mysql][:password]
mysql_database_user hive_user do
  connection    mysql_connection_info
  database_name hive_database
  host          '%'
  password      hive_pass
  privileges    [:select,:insert,:update,:delete]
  action        [:create, :grant]
end

remote_file File.join(node[:hive][:home_dir], 'lib', node[:hive][:mysql][:connector_jar] ) do
  source node[:hive][:mysql][:connector_location]
  mode 0644
end
