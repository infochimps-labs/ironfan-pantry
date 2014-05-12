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
when 'source', 'prebuild', 'package'
  include_recipe "zabbix::agent_#{node.zabbix.agent.install_method}"
else
  warn "Invalid install method '#{node.zabbix.agent.install_method}'.  Only 'source' and 'prebuild' are supported for Zabbix agent."
end

zabbix_servers = discover_all(:zabbix, :server)

template(File.join(node[:zabbix][:conf_dir], "zabbix_agentd.conf")) do
  source    "zabbix_agentd.conf.erb"
  group     node[:zabbix][:group]
  mode      "640"
  notifies  :restart, "service[zabbix_agentd]", :delayed
  variables :server_ips => zabbix_servers.map(&:private_ip).uniq
end

# We'd like to use runit to manage the zabbix_agentd process but it
# unfortunately cannot launch without daemonizing itself.
template "/etc/init.d/zabbix_agentd" do
  source    "zabbix_agentd.init.erb"
  group     node[:zabbix][:group]
  mode      "755"
  notifies  :restart, "service[zabbix_agentd]", :delayed
end

service "zabbix_agentd" do
  supports :status => true, :start => true, :stop => true
  action [ :start, :enable ]
end

include_recipe "zabbix::unmonitor_this_host_on_shutdown" if node.zabbix.agent.unmonitor_on_shutdown

announce(:zabbix, :agent, {
  # register in the same realm, for discovery purposes
  realm:  discovery_realm(:zabbix, :server),
  logs:   { agent:  node.zabbix.agent.log_dir },
  ports:  { agent:  {
      port:     node.zabbix.agent.port,
      monitor:  false
    }
  },
  daemons:  { agent:  { service: 'zabbix_agentd' } }
})

