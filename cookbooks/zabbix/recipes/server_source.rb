#
# Cookbook Name::       zabbix
# Description::         Downloads, builds, configures, & launches Zabbix server from source.
# Recipe::              server_source
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
  %w{ fping libmysql++-dev libmysql++3 libcurl3 libiksemel-dev libiksemel3 libsnmp-dev snmp libiksemel-utils libcurl4-openssl-dev }.each do |pck|
    package "#{pck}" do
      action :install
    end
  end
when "centos"
  %w{ libcurl-devel net-snmp-devel }.each do |pck|
    package "#{pck}" do
      action :install
    end
  end
else
  log "No #{node.platform} support yet"
end

# Download zabbix source code
remote_file "/opt/zabbix-#{node.zabbix.server.version}.tar.gz" do
  source "http://freefr.dl.sourceforge.net/project/zabbix/#{node.zabbix.server.branch}/#{node.zabbix.server.version}/zabbix-#{node.zabbix.server.version}.tar.gz"
  mode "0644"
  action :create
  not_if { File.exists?(self.path) }
end

# installation of zabbix bin
bash "install_zabbix_server" do
  user "root"
  cwd "/opt"
  notifies :restart, "service[zabbix_server]"
  code <<-EOH
  tar xvfz /opt/zabbix-#{node.zabbix.server.version}.tar.gz
  (cd zabbix-#{node.zabbix.server.version} && ./configure --enable-server #{node.zabbix.server.configure_options.join(" ")})
  (cd zabbix-#{node.zabbix.server.version} && make install)
  EOH
  not_if { File.exists?("/opt/zabbix-#{node.zabbix.server.version}") }
end

# Install Init script
case node.platform
when 'debian','ubuntu'
  init_template = "zabbix_server.init.erb"
when 'centos'
  init_template = "zabbix_server.init.centos.erb"
else
  log("No init.d for #{node.platform}, trying the Debian-style") { level :warn }
  init_template = "zabbix_server.init.erb"
end
template "/etc/init.d/zabbix_server" do
  source init_template
  owner "root"
  group "root"
  mode "754"
end

# install zabbix server conf
template "/etc/zabbix/zabbix_server.conf" do
  source "zabbix_server.conf.erb"
  owner "root"
  group "root"
  mode "644"
  notifies :restart, "service[zabbix_server]"
end

# Define zabbix_agentd service
service "zabbix_server" do
  supports :status => true, :start => true, :stop => true, :restart => true
  action [ :enable ]
end
