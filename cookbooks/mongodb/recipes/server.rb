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

include_recipe 'volumes'

volume_dirs('mongodb.data') do
  type          :local unless node[:mongodb][:server][:persistent]
  selects       :single
  mode          "0770"
end

include_recipe 'mongodb::install_from_package'

#
# Create service
#
template "/etc/mongodb.conf" do
  source        "mongodb.conf.erb"
  backup        false
  mode          "0644"
end

service 'mongodb' do
  action :restart
end

#
# Announcments
# 
announce(:mongodb, :server, {
           :logs  => { :server => node[:mongodb][:log_path] },
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

