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

base_name = platform_family?('rhel') ? 'mongod' : 'mongodb'
log_dir_name = platform_family?('rhel') ? 'mongo' : base_name
log_path = "/var/log/#{log_dir_name}/#{base_name}.log"

#
# Create service
#
template "/etc/#{base_name}.conf" do
  source        "mongodb.conf.erb"
  variables     ({ :log_path => log_path })
  backup        false
  mode          "0644"
end

service base_name do
  action :restart
end

#
# Announcments
# 
announce(:mongodb, :server, {
  logs:    { server: File.dirname(log_path) },
  ports:   {
    http: { port: node[:mongodb][:server][:mongod_port], protocol: 'http' },
  },
  daemons: {
    mongod: {
      name: 'mongod',
      user: base_name,
      cmd:  'mongod'
    }
  }
})
