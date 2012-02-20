#
# Cookbook Name::       ganglia
# Description::         Writes the ganglia config files filled with auto-discovered goodness
# Recipe::              config_files
# Author::              Philip (flip) Kromer - Infochimps, Inc
#
# Copyright 2011, Philip (flip) Kromer - Infochimps, Inc
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

#
# Conf file -- auto-discovers ganglia agents
#

monitor_groups = Hash.new{|h,k| h[k] = [] }
discover_all(:ganglia, :agent).each do |svr|
  monitor_groups[svr.name] << "#{svr.private_ip}:#{svr.node_info[:rcv_port]}"
end

# <%- servers.map{|svr| "#{svr[:private_ip]}:#{svr[:rcv_port]}" }.join(' ')  %>
# <%- all_service_info("#{node[:cluster_name]}-ganglia_agent").each{|svr| monitor_groups[svr[:name]] << svr } %>

template "#{node[:ganglia][:conf_dir]}/gmetad.conf" do
  source        "gmetad.conf.erb"
  backup        false
  owner         "ganglia"
  group         "ganglia"
  mode          "0644"
  notifies  :restart, "service[ganglia_server]", :delayed if startable?(node[:ganglia][:server])
  variables :monitor_groups => monitor_groups
end

template "#{node[:ganglia][:conf_dir]}/gmond.conf" do
  source        "gmond.conf.erb"
  backup        false
  owner         "ganglia"
  group         "ganglia"
  mode          "0644"
  send_addr = discover(:ganglia, :server).private_ip rescue nil
  variables(
    :cluster => {
      :name      => node[:cluster_name],
      :send_addr => send_addr,
      :send_port => node[:ganglia][:send_port],
      :rcv_port  => node[:ganglia][:rcv_port ],
    })
  notifies      :restart, 'service[ganglia_agent]' if startable?(node[:ganglia][:agent])
end
