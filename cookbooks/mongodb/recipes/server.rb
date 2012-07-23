#
# Cookbook Name:: mongodb
# Recipe:: source
#
# Author:: Gerhard Lazu (<gerhard.lazu@papercavalier.com>)
#
# Copyright 2010, Paper Cavalier, LLC
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

init_system = node[:mongodb][:init_system]
server_init = Mash.new(
  :type     => "mongodb",
  :daemon   => "mongod"
)

mongo_user = mongo_group = node[:mongodb][:user]
server_init[:basename]   = node[:mongodb][:user]
daemon_user(node[:mongodb][:user].to_sym)

# Data onto a bulk device
volume_dirs('mongodb.data') do
  type          :persistent
  selects       :all
  path          'mongodb'
  mode          "0700"
end


# directory node[:mongodb][:datadir] do
#   owner mongo_user
#   group mongo_group
#   mode 0755
#   recursive true
# end

file node[:mongodb][:logfile] do
  owner mongo_user
  group mongo_group
  mode 0644
  action :create_if_missing
  backup false
end

template node[:mongodb][:config] do
  source "mongodb.conf.erb"
  owner mongo_user
  group mongo_group
  mode 0644
  backup false
end

case init_system
when "upstart"
  template '/etc/init/mongodb.conf' do
    source "mongod.upstart.erb"
    owner "root"
    group "root"
    mode 0644
    backup false
    variables(:server_init => server_init)
  end
when "sysv"
  template "/etc/init.d/mongodb" do
    source "mongodb.init.erb"
    mode 0755
    backup false
    variables(:server_init => server_init)
  end
else
  # Do nothing, and assume the install_from cookbooks
  #   put down a correctly formatted init script
end

service server_init[:basename] do
  supports :start => true, :stop => true, "force-stop" => true, :restart => true, "force-reload" => true, :status => true
  action        node[:mongodb][:server][:run_state]
  subscribes :restart, resources(:template => node[:mongodb][:config])
  case init_system
  when "upstart"
    subscribes :restart, resources(:template => "/etc/init/mongodb.conf")
    provider Chef::Provider::Service::Upstart
  when "sysv"
    subscribes :restart, resources(:template => "/etc/init.d/mongodb")
  end
end

template "/etc/logrotate.d/#{server_init[:basename]}" do
  source "mongodb.logrotate.erb"
  owner mongo_user
  group mongo_group
  mode "0644"
  backup false
  variables(:logfile => node[:mongodb][:logfile])
end

announce(:mongodb, :server)
