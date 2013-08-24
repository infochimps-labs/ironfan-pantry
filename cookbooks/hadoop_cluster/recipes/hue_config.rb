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

if node[:hadoop][:hue][:ssl][:key]
  file File.join(node[:hadoop][:hue][:conf_dir], 'hue.key') do
    owner    node[:hadoop][:hue][:user]
    mode     '0600'
    contents node[:hadoop][:hue][:ssl][:key]
  end
end

if node[:hadoop][:hue][:ssl][:certificate]
  file File.join(node[:hadoop][:hue][:conf_dir], 'hue.crt') do
    owner    node[:hadoop][:hue][:user]
    mode     '0600'
    contents node[:hadoop][:hue][:ssl][:certificate]
  end
end

require 'securerandom'
secret_key = SecureRandom.hex

namenode   = discover(:hadoop, :namenode)
jobtracker = discover(:hadoop, :jobtracker)

template File.join(node[:hadoop][:hue][:conf_dir], 'hue.ini') do
  mode     "0644"
  variables(:hue => node[:hadoop][:hue], :hadoop => node[:hadoop], secret_key: secret_key, namenode: namenode, jobtracker: jobtracker)
  source   "hue.ini.erb"
end
