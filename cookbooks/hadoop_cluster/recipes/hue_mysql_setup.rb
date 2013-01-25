#
# Cookbook Name::       hadoop_cluster
# Description::         Configures Hadoop Hue MySQL database
# Recipe::              hue_mysql_setup
# Author::              Josh Bronson - Infochimps, Inc
#
# Copyright 2012 Infochimps, Inc
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

# Assume mysql is running on the local machine.
share_dir           = node[:hadoop][:hue][:share_dir]
hue_exec            = File.join(share_dir, "build/env/bin/hue")
config_dump_file    = '/tmp/hue_config_dump.json'
mysql_host          = node[:hadoop][:hue][:mysql_host]
mysql_hue_username  = node[:hadoop][:hue][:mysql_hue_username]
mysql_user_password = node[:hadoop][:hue][:mysql_user_password]
mysql_root_password = node['mysql']['server_root_password']
mysql_database_name = node[:hadoop][:hue][:mysql_database]

hue_mysql_conn = {
  :host     => mysql_host,
  :username => mysql_hue_username,
  :password => mysql_user_password,
},

# This should probably be replaced with calls to the mysql_database
# and mysql_database_user resources.

check_database_exists = "SHOW DATABASES;"
delete_content_type = "DELETE FROM #{mysql_database_name}.django_content_type;"

create_user_and_database_sql = [
                                "CREATE DATABASE IF NOT EXISTS #{mysql_database_name}",
                                "USE #{mysql_database_name}",
                                
                                # This will create the user if it does not already exist.
                                [
                                 "GRANT all ON #{mysql_database_name}.*",
                                 "TO '#{mysql_hue_username}'@'%'",
                                 "IDENTIFIED BY '#{mysql_user_password}'",
                                ].join(" "),
                                
                                ""].join(";")

create_user_and_database = [
                            "/usr/bin/mysql",
                            "-h",  mysql_host,
                             "-u root",
                            ["-p", mysql_root_password].join,
                            "-e \"#{create_user_and_database_sql}\"",  
                           ].join(" "),

hue_sync                = "#{hue_exec} syncdb --noinput"

configure_bash_commands = [create_user_and_database, hue_sync].join(" && ")

#--------------------------------------------------------------------------------
# execution
#--------------------------------------------------------------------------------

execute "create and configure mysql database and hue user" do
  user node[:hadoop][:hue][:user]
  cwd share_dir
  command configure_bash_commands
  not_if [
          [
           "/usr/bin/mysql",
           "-h",  mysql_host,
           "-u root",
           ["-p", mysql_root_password].join,
           "-e \"#{check_database_exists}\"",  
          ].join(" "),
          "grep #{mysql_database_name}",
         ].join(" | ")
end
