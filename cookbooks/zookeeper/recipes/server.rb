#
# Cookbook Name::       zookeeper
# Description::         Installs Zookeeper server, sets up and starts service
# Recipe::              server
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

include_recipe 'runit'
include_recipe 'silverware'
include_recipe 'zookeeper'


# === Locations

# Zookeeper snapshots on a single persistent drive
volume_dirs('zookeeper.data') do
  type          :persistent
  selects       :single
  path          'zookeeper/data'
end

# Zookeeper transaction journal storage on a single scratch dir
volume_dirs('zookeeper.journal') do
  type          :local
  selects       :single
  path          'zookeeper/txlog'
end

standard_dirs('zookeeper.server') do
  directories   :data_dir, :journal_dir
end

# === Install

# Only install the software, not the hadoop-zookeeper-server (which runs automatically)
package "hadoop-zookeeper"

# Here to clean up the old version that installed hadoop-zookeeper-server
kill_old_service('hadoop-zookeeper-server'){ pattern 'zookeeper' ; only_if{ File.exists?("/etc/init.d/hadoop-zookeeper-server") } }

# === Announce

# JMX should listen on the public interface
node[:zookeeper][:jmx_dash_addr] = public_ip_of(node)

# * zkid auto-assigment happens in server file only; clients don't deserve zkids.
# * preparation of zookeeper_host list happens in one place
# * Note to all: don't rely on the zkid assignment. Set it in the cluster definition

# Auto-assign zkid that is likely to be stable and predictable In
# practice: don't rely on this. Just set the zkid in your cluster
# definition before launch
if ((not node[:zookeeper][:zkid]) || (node[:zookeeper][:zkid].to_s != ''))
  # I apologize, future me and you, for what you see here. @mrflip
  #
  # So that node IDs are predictable, use the server's index (eg 'foo-bar-3' = zk id 3)
  # If zookeeper servers span facets, give each a well-sized offset in facet_role
  # (if 'bink' nodes have zkid_offset 10, 'foo-bink-7' would get zkid 17)
  #
  node[:zookeeper][:zkid]  = node[:facet_index]
  node[:zookeeper][:zkid] += node[:zookeeper][:zkid_offset].to_i if node[:zookeeper][:zkid_offset]
end

runit_service "zookeeper_server" do
  run_state     node[:zookeeper][:server][:run_state]
  options       node[:zookeeper]
end

#
# Announcements 
#

# TODO Elegently figure out when to announce election and leader ports as they are not always open.  

# NOTE: iron_cuke will not pick up the daemon as running due to username length > 8, len(zookeeper) = 9 

announce(:zookeeper, :server, {
           :logs  => { :server => node[:zookeeper][:log_dir] },
           :ports => {
             :client_port => {
               :port      => node[:zookeeper][:client_port]
             },
             :jmx => { 
               :port => node[:zookeeper][:jmx_dash_port],
               :dashboard => true
             }, 
           },
           :daemons => {
             :java => {
               :name    => 'java',
               :user    => node[:zookeeper][:user],
               :cmd     => 'QuorumPeerMain'
             }
           }
         })
