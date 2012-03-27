#
# Cookbook Name::       flume
# Description::         Configures Flume Node, installs and starts service
# Recipe::              node
# Author::              Chris Howe - Infochimps, Inc
#
# Copyright 2011, Infochimps, Inc.
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

include_recipe 'flume'
include_recipe 'runit'

package "flume-node"

standard_dirs('flume.agent') do
  directories [:log_dir]
end

#
# Create service
#

kill_old_service('flume-node'){ only_if{ File.exists?("/etc/init.d/flume-node") } }

runit_service 'flume_agent' do
  run_state     node[:flume][:agent][:run_state]
  subscribes    :restart, resources( :template => [ File.join(node[:flume][:conf_dir], "flume-site.xml"), File.join(node[:flume][:home_dir], "bin/flume-env.sh") ] )
  options       Mash.new().merge(node[:flume]).merge(node[:flume][:agent]).merge({
      :service_command    => 'node',
      :zookeeper_home_dir => node[:zookeeper][:home_dir],
    })
end

#
# Announce flume agent capability
#

announce(:flume, :agent, {
    :logs    => {
      :node => { :glob => File.join(node[:flume][:agent][:log_dir], 'flume-flume-node*.log'), :logrotate => false, :archive => false } },
    :ports   => {
      :status => { :port => 35862, :protocol => 'http', :dashboard => true }  },
    :daemons => {
      :java => { :name => 'java', :cmd => 'FlumeNode', :number => 2 } },
  })
