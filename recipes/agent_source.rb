#
# Cookbook Name::       zabbix
# Description::         Downloads, builds, configures, & launches Zabbix agent from source.
# Recipe::              agent_source
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

case node[:platform]
when "ubuntu","debian"
  # install some dependencies
  %w{ fping libcurl3 libiksemel-dev libiksemel3 libsnmp-dev libiksemel-utils libcurl4-openssl-dev }.each do |pck|
    package "#{pck}" do
      action :install
    end
  end
when "centos"
  log "No centos Support yet"
end

server_ips = all_zabbix_server_ips()
# Install configuration
template "/etc/zabbix/zabbix_agentd.conf" do
  source "zabbix_agentd.conf.erb"
  owner "root"
  group "root"
  mode "644"
  notifies :restart, "service[zabbix_agentd]"
  variables :server_ips => server_ips
end

# Install Init script
template "/etc/init.d/zabbix_agentd" do
  source "zabbix_agentd.init.erb"
  owner "root"
  group "root"
  mode "754"
end

directory "/opt/zabbix-agent-src" do
  action :create
end

# installation of zabbix bin
script "install_zabbix_agent" do
  interpreter "bash"
  user "root"
  cwd "/opt"
  action :nothing
  notifies :restart, "service[zabbix_agentd]"
  code <<-EOH
  tar xvfz zabbix-#{node.zabbix.agent.version}-agent.tar.gz -C /opt/zabbix-agent-src/
  (cd zabbix-agent-src/zabbix-#{node.zabbix.agent.version} && ./configure --enable-agent #{node.zabbix.agent.configure_options.join(" ")})
  (cd zabbix-agent-src/zabbix-#{node.zabbix.agent.version} && make install)
  EOH
end

# Download zabbix source code
remote_file "/opt/zabbix-#{node.zabbix.agent.version}-agent.tar.gz" do
  source "http://freefr.dl.sourceforge.net/project/zabbix/#{node.zabbix.agent.branch}/#{node.zabbix.agent.version}/zabbix-#{node.zabbix.agent.version}.tar.gz"
  mode "0644"
  action :create_if_missing
  notifies :run, "script[install_zabbix_agent]"
end

# Define zabbix_agentd service
service "zabbix_agentd" do
  supports :status => true, :start => true, :stop => true
  action [ :start, :enable ]
end
