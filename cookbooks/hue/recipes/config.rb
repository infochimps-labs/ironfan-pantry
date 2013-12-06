#
# Cookbook Name::       hadoop_cluster
# Description::         Configures Hadoop Hue (Hadoop Workspace)
# Recipe::              hue_config
# Author::              Josh Bronson - Infochimps, Inc
#
# Copyright 2012 Infochimps, Inc
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


# pull in node attrs for configuration
include_recipe "hadoop"
include_recipe "hive"
include_recipe "impala"
include_recipe "pig"

if node[:hue][:ssl][:key]
  file File.join(node[:hue][:conf_dir], 'hue.key') do
    owner    node[:hue][:user]
    mode     '0600'
    content  node[:hue][:ssl][:key]
    action   :create
    notifies :restart, 'service[hue]', :delayed
  end
end

if node[:hue][:ssl][:certificate]
  file File.join(node[:hue][:conf_dir], 'hue.crt') do
    owner    node[:hue][:user]
    mode     '0600'
    content  node[:hue][:ssl][:certificate]
    action   :create
    notifies :restart, 'service[hue]', :delayed
  end
end

template File.join(node[:hue][:conf_dir], 'log.conf') do
  source 'hue.log.conf.erb'
  mode   '0644'
  action :create
  notifies :restart, 'service[hue]', :delayed
end

template File.join(node[:hue][:conf_dir], 'log4j.properties') do
  source 'hue.log4j.properties.erb'
  mode   '0644'
  action :create
  notifies :restart, 'service[hue]', :delayed
end

require 'securerandom'
secret_key = SecureRandom.hex

namenode   = discover(:hadoop, :namenode)
jobtracker = discover(:hadoop, :jobtracker)
impala     = discover(:impala, :server)

template File.join(node[:hue][:conf_dir], 'hue.ini') do
  mode     "0644"
  variables(:hue => node[:hue], :hadoop => node[:hadoop], :hive => node[:hive], secret_key: secret_key, namenode: namenode, jobtracker: jobtracker, :fqdn => node[:route53][:fqdn], :impala => impala)
  source   "hue.ini.erb"
  notifies :restart, 'service[hue]', :delayed
end
