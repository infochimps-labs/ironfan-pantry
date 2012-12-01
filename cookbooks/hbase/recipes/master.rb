#
# Cookbook Name::       hbase
# Description::         HBase Master
# Recipe::              master
# Author::              Chris Howe - Infochimps, Inc
#
# Copyright 2011, Chris Howe - Infochimps, Inc
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

include_recipe 'hbase'
include_recipe 'runit'

# Install
package "hadoop-hbase-master"

# Set up service
runit_service "hbase_master" do
  run_state     node[:hbase][:master][:run_state]
  options       Mash.new(:service_name => 'master').merge(node[:hbase]).merge(node[:hbase][:master])
end

kill_old_service("hadoop-hbase-master"){ hard(:real_hard) ; only_if{ File.exists?("/etc/init.d/hadoop-hbase-master") } }

announce(:hbase, :master, {
           :logs  => { :master => node[:hbase][:log_dir] },
           :ports => {
#             :bind_port     => { :port => node[:hbase][:master][:bind_port] }, # Not available via localhost so fails iron_cuke test
             :dash_port     => { :port => node[:hbase][:master][:dash_port], :dashboard => true },
             :jmx_dash_port => { :port => node[:hbase][:master][:jmx_dash_port], :dashboard => true },
           },
           :daemons => {
             :java => { :name => 'java', :user => node[:hbase][:user], :cmd => 'org.apache.hadoop.hbase.master.HMaster' } 
           }
        })

