#
# Cookbook Name::       zabbix
# Description::         Downloads, configures, & launches pre-built Zabbix agent
# Recipe::              agent_prebuild
# Author::              Nacer Laradji (<nacer.laradji@gmail.com>)
#
# Copyright 2011, Efactures
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

server_ips = all_zabbix_server_ips()
# Install configuration
template "/etc/zabbix/zabbix_agentd.conf" do
  source "zabbix_agentd.conf.erb"
  owner "root"
  group "root"
  mode "644"
  notifies :restart, "service[zabbix_agentd]", :delayed
  variables :server_ips => server_ips
end

# Install Init script
template "/etc/init.d/zabbix_agentd" do
  source "zabbix_agentd.init.erb"
  owner "root"
  group "root"
  mode "754"
end

# Define arch for binaries
if node.kernel.machine == "x86_64"
  $zabbix_arch = "amd64"
elsif node.kernel.machine == "i686"
  $zabbix_arch = "i386"
end

# installation of zabbix bin
script "install_zabbix_agent" do
interpreter "bash"
user "root"
cwd "/opt/zabbix"
action :nothing
notifies :restart, "service[zabbix_agentd]"
code <<-EOH
tar xvfz /opt/zabbix_agents_#{node.zabbix.agent.version}.linux2_6.#{$zabbix_arch}.tar.gz
EOH
end
  
# Download and intall zabbix agent bins.
remote_file "/opt/zabbix_agents_#{node.zabbix.agent.version}.linux2_6.#{$zabbix_arch}.tar.gz" do
  source "http://www.zabbix.com/downloads/#{node.zabbix.agent.version}/zabbix_agents_#{node.zabbix.agent.version}.linux2_6.#{$zabbix_arch}.tar.gz"
  mode "0644"
  action :create_if_missing
  notifies :run, "script[install_zabbix_agent]"
end

# Define zabbix_agentd service
service "zabbix_agentd" do
  supports :status => true, :start => true, :stop => true
  action [ :start, :enable ]
end

