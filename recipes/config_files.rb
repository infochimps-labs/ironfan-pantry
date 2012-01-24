#
# Cookbook Name::       zookeeper
# Description::         Config files -- include this last after discovery
# Recipe::              default
# Author::              Chris Howe - Infochimps, Inc
#
# Copyright 2010, Infochimps, Inc.
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
# Config files
#
zookeeper_hosts = discover_all(:zookeeper, :server).sort_by{|cp| cp.node.name }.map(&:private_ip)

# use explicit value if set, otherwise make the leader a server iff there are
# four or more zookeepers kicking around
leader_is_also_server = node[:zookeeper][:leader_is_also_server]
if (leader_is_also_server.to_s == 'auto')
  leader_is_also_server = (zookeeper_hosts.length >= 4)
end

myid = zookeeper_hosts.find_index( private_ip_of(node) )
template_variables = {
  :zookeeper         => node[:zookeeper],
  :zookeeper_hosts   => zookeeper_hosts,
  :myid              => myid,
}

%w[ zoo.cfg log4j.properties].each do |conf_file|
  template "#{node[:zookeeper][:conf_dir]}/#{conf_file}" do
    variables   template_variables
    owner       "root"
    mode        "0644"
    source      "#{conf_file}.erb"
  end
end

template "#{node[:zookeeper][:data_dir]}/myid" do
  owner         "zookeeper"
  mode          "0644"
  variables     template_variables
  source        "myid.erb"
end
