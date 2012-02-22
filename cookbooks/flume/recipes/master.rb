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

package "flume-master"

service "flume-master" do
  supports      :restart => true, :start=>true, :stop => true
  subscribes    :restart, resources( :template => ["/usr/lib/flume/conf/flume-site.xml","/usr/lib/flume/bin/flume-env.sh"] )
  action        node[:flume][:master][:run_state]
end

announce(:flume, :master,
         :logs    => {
           :master => { :regexp => File.join(node[:flume][:log_dir], 'flume-flume-master*.log'), :logrotate => false }
         },
         :ports   => {
           :status    => { :port => 35871, :protocol => 'http', :dashboard => true },
           :heartbeat => 35872,
           :admin     => 35873,
           :report    => 45678
         }.tap do |ports|
           ports[:zookeeper] = node[:flume][:master][:zookeeper_port] unless node[:flume][:master][:external_zookeeper]

           # FIXME -- add the gossip port only if it's being used,
           # i.e. - we have multiple masters?
           # ports[:gossip] = 57890
         end,
         :daemons => {
           :java => { :name => 'java', :cmd => 'FlumeMaster', :number => 2 }
         }
         )
