#
# Cookbook Name:: mongodb
# Recipe:: mongos
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
  :type     => "mongos",
  :daemon   => "mongos",
  :basename => "mongos"
)

file node[:mongodb][:mongos][:logfile] do
  owner "mongodb"
  group "mongodb"
  mode 0644
  action :create_if_missing
  backup false
end

template node[:mongodb][:mongos][:config] do
  source "mongos.conf.erb"
  owner "mongodb"
  group "mongodb"
  mode 0644
  backup false
end

configdb_servers = search(:node, 'recipes:mongodb\:\:config_server')
# FIXME: Don't depend on EC2 (GH-10)
configdb_server_list = configdb_servers.collect { |x| x.ec2.local_hostname }.join(',')

case init_system
when "upstart"
  template "/etc/init/mongos.conf" do
    source "mongod.upstart.erb"
    owner "root"
    group "root"
    mode 0644
    backup false
    variables(:server_init => server_init, :configdb_server_list => configdb_server_list)
  end
when "sysv"
  template "/etc/init.d/mongos" do
    source "mongodb.init.erb"
    mode 0755
    backup false
    variables(:server_init => server_init, :configdb_server_list => configdb_server_list)
  end
end

service "mongos" do
  supports :start => true, :stop => true, "force-stop" => true, :restart => true, "force-reload" => true, :status => true
  action [:enable, :start]
  subscribes :restart, resources(:template => node[:mongodb][:mongos][:config])
  case init_system
  when "upstart"
    subscribes :restart, resources(:template => "/etc/init/mongos.conf")
    provider Chef::Provider::Service::Upstart
  else
    subscribes :restart, resources(:template => "/etc/init.d/mongos")
  end
end

template "/etc/logrotate.d/#{server_init[:basename]}" do
  source "mongodb.logrotate.erb"
  owner "mongodb"
  group "mongodb"
  mode "0644"
  backup false
  variables(:logfile => node[:mongodb][:mongos][:logfile])
end

