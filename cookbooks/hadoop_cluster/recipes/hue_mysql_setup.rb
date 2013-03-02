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
pip                 = File.join(node[:hadoop][:hue][:share_dir],
                                "build/env/bin/pip")
hue_exec            = File.join(share_dir, "build/env/bin/hue")
config_dump_file    = '/tmp/hue_config_dump.json'
mysql_hue_username  = node[:hadoop][:hue][:mysql_hue_username]
mysql_user_password = node[:hadoop][:hue][:mysql_user_password]
mysql_root_password = node['mysql']['server_root_password']
mysql_database_name = node[:hadoop][:hue][:mysql_database]

# This should probably be replaced with calls to the mysql_database
# and mysql_database_user resources.

check_database_exists = "SHOW DATABASES;"

create_user_and_database_sql = [
                                "CREATE DATABASE IF NOT EXISTS #{mysql_database_name}",
                                "USE #{mysql_database_name}",

                                # Remove the anonymous user so we can
                                # log in. For the sake of idempotency,
                                # first we'll have to create the user
                                # with a harmless permission.
                                "GRANT USAGE ON *.* TO ''@'localhost'",
                                "DROP USER ''@'localhost'",
                                
                                # This will create the user if it does not already exist.
                                [
                                 "GRANT all ON #{mysql_database_name}.*",
                                 "TO '#{mysql_hue_username}'@'%'",
                                 "IDENTIFIED BY '#{mysql_user_password}'",
                                ].join(" "),
                                
                                ""].join(";")

create_user_and_database = [
                            "/usr/bin/mysql",
                             "-u root",
                            ["-p", mysql_root_password].join,
                            "-e \"#{create_user_and_database_sql}\"",  
                           ].join(" "),

hue_sync                = "#{hue_exec} syncdb --noinput"

configure_bash_commands = [create_user_and_database, hue_sync].join(" && ")

#--------------------------------------------------------------------------------
# execution
#--------------------------------------------------------------------------------

# Reinstall to ensure that MySQLdb is compiled against the correct
# version. See
# 
# http://mysql-python.sourceforge.net/FAQ.html#importerror
script "reinstall mysql-python" do
  interpreter "bash"
  user "root"
  code <<-EOF
    #{pip} uninstall -y MySQL-python
    #{pip} install MySQL-python
  EOF
end

execute "create and configure mysql database and hue user" do
  user node[:hadoop][:hue][:user]
  cwd share_dir
  command configure_bash_commands
  not_if [
          [
           "/usr/bin/mysql",
           "-u root",
           ["-p", mysql_root_password].join,
           "-e \"#{check_database_exists}\"",  
          ].join(" "),
          "grep #{mysql_database_name}",
         ].join(" | ")
end
