#
# Cookbook Name::       zabbix
# Description::         Adds a system shutdown hook to unmonitor this node's Zabbix host
# Recipe::              unmonitor_this_host_on_shutdown
# Author::              Dhruv Bansal (<dhruv@infochimps.com>), Nacer Laradji (<nacer.laradji@gmail.com>)
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

zabbix_server         = discover(:zabbix, :server)
unmonitor_script_path = File.join(node[:zabbix][:conf_dir], "external_scripts", "unmonitor_zabbix_host.rb")

template unmonitor_script_path do
  source    "unmonitor_zabbix_host.rb.erb"
  mode      '0770'
  variables :ip => (zabbix_server && zabbix_server.private_ip)
  action    :create
end

# FIXME -- there's gotta be some built-on Chef resource or existing
# cookbook to add system shutdown hooks...
case node.platform
when 'ubuntu', 'debian'
  template "/etc/init/unmonitor_zabbix_host.conf" do
    source 'unmonitor_zabbix_host.conf.erb'
    group  node[:zabbix][:group]
    mode   "0644"
    action :create
  end
else
  Chef::Log.error("Will not automatically unmonitor this node's Zabbix host when this node shuts down (don't know how configure #{node.platform} to run shutdown scripts).")
end
