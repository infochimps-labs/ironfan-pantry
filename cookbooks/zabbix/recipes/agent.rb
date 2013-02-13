#
# Cookbook Name::       zabbix
# Description::         Installs and launches Zabbix agent.
# Recipe::              agent
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

include_recipe("zabbix::default")

standard_dirs('zabbix.agent') do
  directories :log_dir
end

case node.zabbix.agent.install_method
when 'source', 'prebuild'
  include_recipe "zabbix::agent_#{node.zabbix.agent.install_method}"
else
  warn "Invalid install method '#{node.zabbix.agent.install_method}'.  Only 'source' and 'prebuild' are supported for Zabbix agent."
end

server_ips       = all_zabbix_server_ips()
zabbix_server_ip = server_ips.first
template(File.join(node[:zabbix][:conf_dir], "zabbix_agentd.conf")) do
  source    "zabbix_agentd.conf.erb"
  mode      "644"
  notifies  :restart, "service[zabbix_agentd]", :delayed
  variables :server_ips => server_ips
end

template "/etc/init.d/zabbix_agentd" do
  source "zabbix_agentd.init.erb"
  mode   "754"
end

service "zabbix_agentd" do
  supports :status => true, :start => true, :stop => true
  case node.platform
  when 'centos'
    action [ :start ]
  else
    action [ :start, :enable ]
  end
end

if node.zabbix.agent.unmonitor_on_shutdown
  template File.join(node[:zabbix][:conf_dir], "external_scripts", "unmonitor_zabbix_host.rb") do
    source    "unmonitor_zabbix_host.rb.erb"
    mode      '0776'
    variables :ip => zabbix_server_ip
    action    :create
  end
  template "/etc/init/unmonitor_zabbix_host.conf" do
    source 'unmonitor_zabbix_host.conf.erb'
    action :create
  end
end

announce(:zabbix, :agent, {
  # register in the same realm, for discovery purposes
  realm:  discovery_realm(:zabbix, :server),
  logs:   { agent:  node.zabbix.agent.log_dir },
  ports:  { agent:  {
      port:     10051,
      monitor:  false
    }
  },
  daemons:  { agent:  'zabbix_agentd' }
})

