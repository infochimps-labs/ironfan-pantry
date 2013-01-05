#
# Author:: Nathaniel Eliot <temujin9@infochimps.com>
#
# Cookbook Name:: chef
# Recipe:: yum-rbel-install
#
# Copyright 2012, InfoChimps
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

# This is currently somewhat kludgy, being targeted only at CentOS 6 
#   running Ironfan. Most could be adapted to CentOS 5 or RHEL with 
#   minimal changes.
execute 'set up the rbel.frameos.org repository' do
  command 'rpm -Uvh http://rbel.co/rbel6'
  not_if 'rpm -qa | egrep -qx "rbel6-release-.+(|.noarch)"'
end

package 'rubygem-chef-server'

execute 'set up the chef server components' do
  command 'setup-chef-server.sh'
  not_if 'service chef-server status'
end

execute 'patch chef-client to use ruby1.9.2' do
  command 'sed -i~ "s/\/usr\/bin\/ruby/\01.9.2-p290/" /usr/bin/chef-client'
  not_if 'grep ruby1.9.2 /usr/bin/chef-client'
end

# TODO: Set the admin user password based on Chef config. For now, it
#   defaults to 'chef321go'

if platform?('centos')
  # http://jonathanpolansky.com/2010/10/chef-server-connection-failed-to-rabbitmq-using-bunny-protocol-as-user-chef/
  execute "add chef vhost to rabbitmq" do
    command "rabbitmqctl add_vhost /chef"
    not_if "rabbitmqctl list_vhosts | grep '/chef'"
  end

  execute "add chef user to rabbitmq" do
    command "rabbitmqctl add_user chef #{node[:chef_server][:amqp_pass]}"
    not_if "rabbitmqctl list_users | grep 'chef'"
  end

  execute "grant chef user permission to /chef vhost in rabbitmq" do
    command "rabbitmqctl set_permissions -p /chef chef '.*' '.*' '.*'"
    not_if "rabbitmqctl list_user_permissions chef | grep '/chef'"
  end
end