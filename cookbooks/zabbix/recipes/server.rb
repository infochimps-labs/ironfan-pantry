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

template File.join(node[:zabbix][:conf_dir], 'zabbix_server.conf') do
  source   "zabbix_server.conf.erb"
  owner    "root"
  group    "root"
  mode     "644"
  notifies :restart, "service[zabbix_server]", :delayed
end

template "/etc/init.d/zabbix_server" do
  source 'zabbix_server.init.erb'
  mode   '754'
end

service "zabbix_server" do
  supports :status => true, :start => true, :stop => true, :restart => true
  action [ :enable ]
end

announce(:zabbix, :server, {
  logs:  { server: node.zabbix.server.log_dir },
  ports: {
    server: {
      port:    node.zabbix.server.port,
      monitor: false
    },
    trapper: {
      port:    node.zabbix.server.trapper_port,
      monitor: false
    },
    java_gateway: {
      port:    node.zabbix.server.java_gateway_port,
      monitor: false
    }
  },
  daemons: { :server => 'zabbix_server' }
})
