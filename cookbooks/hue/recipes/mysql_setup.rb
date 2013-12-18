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

# We *connect* as the root user but will create the hue user later.
mysql_connection_info = {
  host:     node[:hue][:mysql][:host],
  port:     node[:hue][:mysql][:port],
  username: node[:hue][:mysql][:root_username],
  password: node[:hue][:mysql][:root_password],
}

hue_database = node[:hue][:mysql][:database]


# Reinstall to ensure that MySQLdb is compiled against the correct
# version. See
#
# http://mysql-python.sourceforge.net/FAQ.html#importerror
pip     = File.join(node[:hue][:home_dir], "build/env/bin/pip")
hue_cmd = File.join(node[:hue][:home_dir], "/build/env/bin/hue")
bash "Initialize Hue MySQL database" do
  cwd   node[:hue][:home_dir]
  code  <<-EOF
#{pip} uninstall -y MySQL-python
#{pip} install MySQL-python
#{hue_cmd} syncdb --noinput
EOF
  action :nothing
end

mysql_database hue_database  do
  connection mysql_connection_info
  action     :create
  notifies   :run, resources(bash: "Initialize Hue MySQL database")
end

hue_user = node[:hue][:mysql][:username]
hue_pass = node[:hue][:mysql][:password]
# Creates 'hue'@'%'
mysql_database_user hue_user do
  connection    mysql_connection_info
  database_name hue_database
  host          '%'
  password      hue_pass
  privileges    [:all]
  action        [:create, :grant]
end

# Creates 'hue'@'localhost', 
# since % version doesn't match localhost (mysql claims localhost = unix domain socket)
mysql_database_user 'at_localhost' do
  username      hue_user
  connection    mysql_connection_info
  database_name hue_database
  host          'localhost'
  password      hue_pass
  privileges    [:all]
  action        [:create, :grant]
end
