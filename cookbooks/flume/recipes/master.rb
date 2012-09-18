#
# Cookbook Name::       flume
# Description::         Configures Flume Master, installs and starts service
# Recipe::              master
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

standard_dirs('flume.master') do
  directories [:log_dir]
end

#
# Create service
#
runit_service 'flume_master' do
  run_state     node[:flume][:master][:run_state]
  run_restart   false
  options       Mash.new().merge(node[:flume]).merge(node[:flume][:master]).merge({
      :service_command    => 'master',
      :zookeeper_home_dir => node[:zookeeper][:home_dir],
    })
end

#
# Announce flume master capability
#

announce(:flume, :master, {
    :logs    => {
      :master => { :glob => File.join(node[:flume][:master][:log_dir], 'flume-flume-master*.log'), :logrotate => false, :archive => false }, },
    :ports   => {
      :status    => { :port => 35871, :protocol => 'http', :dashboard => true },
      :heartbeat => 35872,
      :admin     => 35873,
      :report    => 45678
    }.tap do |ports|
      ports[:zookeeper] = node[:flume][:zookeeper][:port] unless node[:flume][:master][:external_zookeeper]
    end,
    :daemons => {
      :java => { :name => 'java', :cmd => 'FlumeMaster' }, 
           },
         })
