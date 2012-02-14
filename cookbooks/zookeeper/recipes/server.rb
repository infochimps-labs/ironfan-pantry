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
include_recipe 'metachef'
include_recipe "zookeeper::default"

# === User

daemon_user(:zookeeper) do
  home          node[:zookeeper][:data_dir]
end

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

package "hadoop-zookeeper-server"

kill_old_service('hadoop-zookeeper-server'){ pattern 'zookeeper' ; only_if{ File.exists?("/etc/init.d/hadoop-zookeeper-server") } }

# === Announce

# JMX should listen on the public interface
node[:zookeeper][:jmx_dash_addr] = public_ip_of(node)

announce(:zookeeper, :server)

runit_service "zookeeper_server" do
  run_state     node[:zookeeper][:server][:run_state]
  options       node[:zookeeper]
end

# === Finalize

include_recipe 'zookeeper::config_files'
