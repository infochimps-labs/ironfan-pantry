#
# Cookbook Name::       cassandra
# Description::         lay in all the config files, now that the order is known.
# Recipe::              config_files
# Author::              Philip (flip) Kromer <flip@infochimps.com>
#
# Copyright 2010, Philip (flip) Kromer
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

# This is racy like a dirty joke at the indy 500 told by Ray Charles to Cagney's
# partner, but any proper fix would require orchestration. Since a node with
# facet_index 0 is always a seed, spinning that one up first leads to reasonable
# results in practice.

# Configure the various addrs for binding
node[:cassandra][:listen_addr] = private_ip_of(node)
node[:cassandra][:rpc_addr]    = private_ip_of(node)

# Discover the other seeds, assuming they've a) announced and b) converged.
seed_ips = discover_all(:cassandra, :seed).sort_by{|s| s.node.name }.map{|s| s.node.ipaddress }.uniq
# stabilize their order.
seed_ips.sort!
node[:cassandra][:seeds] = seed_ips

# Pull the initial token from the node attributes if one is given
if node[:cassandra][:initial_tokens] && (not node[:facet_index].nil?)
  node[:cassandra][:initial_token] = node[:cassandra][:initial_tokens][node[:facet_index].to_i]
end
# If there is an initial token, force auto_bootstrap to false.
node[:cassandra][:auto_bootstrap] = false if node[:cassandra][:initial_token]

template "#{node[:cassandra][:conf_dir]}/cassandra.yaml" do
  source        "cassandra.yaml.erb"
  owner         "root"
  group         "root"
  mode          "0644"
  variables({   :cassandra => node[:cassandra],
                :seeds     => seed_ips })
  notifies      :restart, "service[cassandra]", :delayed if startable?(node[:cassandra])
end

template "#{node[:cassandra][:conf_dir]}/log4j-server.properties" do
  source        "log4j-server.properties.erb"
  owner         "root"
  group         "root"
  mode          "0644"
  variables     :cassandra => node[:cassandra]
  notifies      :restart, "service[cassandra]", :delayed if startable?(node[:cassandra])
end
