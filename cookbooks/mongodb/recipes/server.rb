#
# Cookbook Name::       mongodb
# Description::         Mongodb server
# Recipe::              server
# Author::              brandon.bell
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

include_recipe 'mongodb'
include_recipe 'volumes'
include_recipe 'runit'

#
# Directories
#

volume_dirs('mongodb.data') do
  type          :local unless node[:mongodb][:server][:persistent]
  selects       :single
  mode          "0700"
end

#
# Create service
#

kill_old_service('mongodb')

runit_service "mongodb_server" do
  run_state     node[:mongodb][:server][:run_state]
  options       Mash.new(:service_name => 'server').merge(node[:mongodb]).merge(node[:mongodb][:server])
end

#
# Announcments
# 

announce(:mongodb, :server, {
           :logs  => { :server => node[:mongodb][:log_dir] },
           :ports => {
             :http => { :port => node[:mongodb][:server][:mongod_port], :protocol => 'http' },
           },
           :daemons => {
             :mongod => {
               :name => 'mongod',
               :user => node[:mongodb][:user],
               :cmd  => 'mongod'
             }
           }
         }) 

