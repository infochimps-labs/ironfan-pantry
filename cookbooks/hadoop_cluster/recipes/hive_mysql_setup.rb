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

# Assume mysql is running on the local machine.
mysql_hive_username = node[:hadoop][:hive][:mysql_hive_username]
mysql_user_password = node[:hadoop][:hive][:mysql_user_password]
mysql_root_password = node['mysql']['server_root_password']
mysql_schema_script = File.join(node[:hadoop][:hive][:home_dir], node[:hadoop][:hive][:mysql_upgrade_script])
mysql_database_name = node[:hadoop][:hive][:mysql_database]

# This should probably be replaced with calls to the mysql_database
# and mysql_database_user resources.

mysql_statements = [
                    "CREATE DATABASE IF NOT EXISTS #{mysql_database_name}",
                    "USE #{mysql_database_name}",

                    # This script looks like it's designed to be idempotent.
                    "SOURCE #{mysql_schema_script}",

                    # This will create the user if it does not already exist.
                    [
                     "GRANT SELECT,INSERT,UPDATE,DELETE",
                     "ON #{mysql_database_name}.*",
                     "TO '#{mysql_hive_username}'@'%'",
                     "IDENTIFIED BY '#{mysql_user_password}'",
                    ].join(" "),

                    "REVOKE ALTER,CREATE ON #{mysql_database_name}.* FROM '#{mysql_hive_username}'@'%'",
                    ""].join(";")

#--------------------------------------------------------------------------------
# execution
#--------------------------------------------------------------------------------

remote_file File.join(node[:hadoop][:hive][:home_dir], 'lib', node[:hadoop][:hive][:mysql_connector_jar]) do
  source node[:hadoop][:hive][:mysql_connector_location]
  mode 0644
end

execute "create and configure mysql database and hive user" do
  command [
           "/usr/bin/mysql",
           "-u root",
           ["-p", mysql_root_password].join,
           "-e \"#{mysql_statements}\"",  
          ].join(" ")
end
