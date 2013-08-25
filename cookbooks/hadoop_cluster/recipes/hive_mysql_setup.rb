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

# We *connect* as the root user but will create the hive user later.
mysql_connection_info = {
  host:     node[:hadoop][:hive][:mysql][:host],
  port:     node[:hadoop][:hive][:mysql][:port],
  username: node[:hadoop][:hive][:mysql][:root_username],
  password: node[:hadoop][:hive][:mysql][:root_password],
}

hive_database = node[:hadoop][:hive][:mysql][:database]

mysql_database hive_database  do
  connection mysql_connection_info
  action     :create
end

script_relative_path = node[:hadoop][:hive][:mysql][:upgrade_script].sub(':version:', node[:hadoop][:hive][:version])
script_absolute_path = File.join(node[:hadoop][:hive][:home_dir], script_relative_path)
mysql_database hive_database do
  connection    mysql_connection_info
  action        :query
  sql           "SOURCE #{script_absolute_path}"
end

hive_user = node[:hadoop][:hive][:mysql][:username]
hive_pass = node[:hadoop][:hive][:mysql][:password]
mysql_database_user hive_user do
  connection    mysql_connection_info
  database_name hive_database
  host          '%'
  password      hive_pass
  privileges    [:select,:insert,:update,:delete]
  action        [:create, :grant]
end

remote_file File.join(node[:hadoop][:hive][:home_dir], 'lib', node[:hadoop][:hive][:mysql][:connector_jar] ) do
  source node[:hadoop][:hive][:mysql_connector_location]
  mode 0644
end
