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
  host:     node[:hadoop][:hue][:mysql][:host],
  port:     node[:hadoop][:hue][:mysql][:port],
  username: node[:hadoop][:hue][:mysql][:root_username],
  password: node[:hadoop][:hue][:mysql][:root_password],
}

hue_database = node[:hadoop][:hue][:mysql][:database]


# Reinstall to ensure that MySQLdb is compiled against the correct
# version. See
# 
# http://mysql-python.sourceforge.net/FAQ.html#importerror
pip = File.join(node[:hadoop][:hue][:home_dir], "build/env/bin/pip")
hue_cmd = File.join(node[:hadoop][:hue][:home_dir], "/build/env/bin/hue")
bash "Initialize Hue MySQL database" do
  cwd   node[:hadoop][:hue][:home_dir]
  user  node[:hadoop][:hue][:user]
  code  <<-EOF
sudo #{pip} uninstall -y MySQL-python
sudo #{pip} install MySQL-python
sudo #{hue_cmd} syncdb --noinput
EOF
  action :nothing
end

mysql_database hue_database  do
  connection mysql_connection_info
  action     :create
  notifies   :run, resources(bash: "Initialize Hue MySQL database")
end

hue_user = node[:hadoop][:hue][:mysql][:username]
hue_pass = node[:hadoop][:hue][:mysql][:password]
mysql_database_user hue_user do
  connection    mysql_connection_info
  database_name hue_database
  host          '%'
  password      hue_pass
  privileges    [:all]
  action        [:create, :grant]
end
