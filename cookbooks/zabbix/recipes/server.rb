#
# Cookbook Name::       zabbix
# Description::         Installs and launches Zabbix server.
# Recipe::              server
# Author::              Dhruv Bansal (<dhruv.bansal@infochimps.com>), Nacer Laradji (<nacer.laradji@gmail.com>)
#
# Copyright 2012-2013, Infochimps
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

include_recipe("zabbix::default")

standard_dirs('zabbix.server') do
  directories :log_dir
end

case node.zabbix.server.install_method
when 'source'
  include_recipe "zabbix::server_#{node.zabbix.server.install_method}"
else
  warn "Invalid method '#{node.zabbix.server.install_method}'.  Only the 'source' install method is supported for Zabbix server."
end

include_recipe "zabbix::java_gateway" if node[:zabbix][:java_gateway][:install]

template File.join(node[:zabbix][:conf_dir], 'zabbix_server.conf') do
  source   "zabbix_server.conf.erb"
  group    node[:zabbix][:group]
  mode     "640"
  notifies :restart, "service[zabbix_server]", :delayed
end

# We'd like to use runit to manage the zabbix_server but it
# unfortunately cannot launch without daemonizing itself.
template "/etc/init.d/zabbix_server" do
  source    'zabbix_server.init.erb'
  group     node[:zabbix][:group]
  mode      '755'
  notifies  :restart, "service[zabbix_server]", :delayed
end

service "zabbix_server" do
  supports :start => true, :stop => true, :restart => true
  action [ :start, :enable ]
end

announced_ports = {
  server: {
    port:    node.zabbix.server.port,
    monitor: false
  }
}
announced_daemons = { server: 'zabbix_server' }
announced_logs    = { server: node.zabbix.server.log_dir }

if node[:zabbix][:java_gateway][:install]
  announced_ports[:java_gateway]   = node.zabbix.java_gateway.port
  announced_daemons[:java_gateway] = {
    name: 'java',
    user: 'zabbix',
    cmd:  'zabbix-java-gateway'
  }
  announced_logs[:java_gateway] = node[:zabbix][:java_gateway][:log_dir]
end

announce(:zabbix, :server, {
  logs:    announced_logs,
  ports:   announced_ports,
  daemons: announced_daemons,
})
