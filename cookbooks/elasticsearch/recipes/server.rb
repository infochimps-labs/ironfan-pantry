#
# Cookbook Name::       elasticsearch
# Description::         Server
# Recipe::              server
# Author::              GoTime, modifications by Infochimps
#
# Copyright 2011, GoTime, modifications by Infochimps
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

include_recipe 'runit'
include_recipe 'tuning'

#
# Locations
#

volume_dirs('elasticsearch.data') do
  type          :persistent
  selects       :single
  mode          "0755"
end

volume_dirs('elasticsearch.scratch') do
  type          :local
  selects       :single
  mode          "0700"
end

if node[:elasticsearch][:data_root]
  Chef::Log.warn "The attribute node[:elasticsearch][:data_root] (#{node[:elasticsearch][:data_root]}) is now called node[:elasticsearch][:data_dir], and set by the 'volume_dirs' helper."
  Chef::Log.warn "Please change your role overrides. You may have to remove the node attribute with `knife node edit #{node.name}`."
end

Chef::Log.info node[:elasticsearch].to_hash.inspect

#
# Service
#

runit_service "elasticsearch" do
  run_restart   false   # don't automatically start or restart daemons
  run_state     node[:elasticsearch][:server][:run_state]
  options       node[:elasticsearch]
  start_command         "-w #{node[:elasticsearch][:server][:start_wait]} start"
  restart_command       "-w #{node[:elasticsearch][:server][:start_wait]} restart"
end

## FIXME: Cannot use this syntax currently, see http://tickets.opscode.com/browse/CHEF-1994
# service "elasticsearch" do
#   subscribes    "template[/etc/elasticsearch/elasticsearch.yml]"
# end

# TODO: split httpnode and datanode into separate components
announce(:elasticsearch, :datanode) if node[:elasticsearch][:is_datanode]
announce(:elasticsearch, :httpnode) if node[:elasticsearch][:is_httpnode]

ports = {
  :api  => node[:elasticsearch][:api_port].to_i,
  :jmx  => {
    :port      => node[:elasticsearch][:jmx_dash_port].to_s.split('-').first.to_i,
    :dashboard => true
  }
}

if node[:elasticsearch][:is_httpnode]
  ports[:http] = {
    :port     => node[:elasticsearch][:http_ports].to_s.split('-').first.to_i,
    :protocol => 'http'
  }
end

announce(:elasticsearch, :server, {
           :logs  => { :elasticsearch => node[:elasticsearch][:log_dir] },
           :ports => ports,
           :daemons => {
             :java => {
               :name => 'java',
               :user => node[:elasticsearch][:user],
               :cmd  => 'elasticsearch'
             }
           }
         })

# JMX should listen on the public interface
node.set[:elasticsearch][:jmx_dash_addr] = public_ip_of(node)
