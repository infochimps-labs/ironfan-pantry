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
    package "#{pck}"
  end
when "centos"
  # do nothing special?
else
  log "No #{node.platform} support yet"
end

directory "/opt/zabbix-agent-src" do
  action :create
end

# Download zabbix source code
remote_file "/opt/zabbix-#{node.zabbix.agent.version}-agent.tar.gz" do
  source "http://freefr.dl.sourceforge.net/project/zabbix/#{node.zabbix.agent.branch}/#{node.zabbix.agent.version}/zabbix-#{node.zabbix.agent.version}.tar.gz"
  mode "0644"
  action :create
  not_if { File.exists?(self.path) }
end

# installation of zabbix bin
script "install_zabbix_agent" do
  interpreter "bash"
  user "root"
  cwd "/opt"
  notifies :restart, "service[zabbix_agentd]"
  code <<-EOH
  tar xvfz zabbix-#{node.zabbix.agent.version}-agent.tar.gz -C /opt/zabbix-agent-src/
  (cd zabbix-agent-src/zabbix-#{node.zabbix.agent.version} && ./configure --enable-agent #{node.zabbix.agent.configure_options.join(" ")})
  (cd zabbix-agent-src/zabbix-#{node.zabbix.agent.version} && make install)
  EOH
  not_if { File.exists?("/opt/zabbix-agent-src/zabbix-#{node.zabbix.agent.version}") }
end

case node.platform
when 'debian','ubuntu'
  init_template = "zabbix_agentd.init.erb"
when 'centos'
  init_template = "zabbix_agentd.init.centos.erb"
else
  log("No init.d for #{node.platform}, trying the Debian-style") { level :warn }
  init_template = "zabbix_agentd.init.erb"
end
template "/etc/init.d/zabbix_agentd" do
  source init_template
  owner "root"
  group "root"
  mode "754"
end

# Define zabbix_agentd service
service "zabbix_agentd" do
  supports :status => true, :start => true, :stop => true
  case node.platform
  when 'centos'
    action [ :start ]
  else
    action [ :start, :enable ]
  end
end
