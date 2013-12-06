 #
# Cookbook Name::       hadoop_cluster
# Description::         Configures Hadoop Hive (SQL with HDFS backend)
# Recipe::              hive_config
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

include_recipe 'hadoop'

template File.join(node[:hive][:conf_dir], 'hive-log4j.properties') do
  mode   "0644"
  source "hive.log4j.properties.erb"
end

war_version = [node[:hive][:version], node[:apt][:cloudera][:release_name]].map(&:to_s).join('-')
metastore   = discover(:hive, :metastore)

template File.join(node[:hive][:conf_dir], 'hive-env.sh') do
  mode "0644"
  variables(:hive => node[:hive], war_version: war_version, :metastore => { :host => metastore.private_ip })
  source "hive-env.sh.erb"
  notify_startable_services(:hive, [:server, :metastore])
end

template File.join(node[:hive][:conf_dir], 'hive-site.xml') do
  mode "0644"
  variables(:hive => node[:hive], war_version: war_version, :metastore => { :host => metastore.private_ip })
  source "hive-site.xml.erb"
  notify_startable_services(:hive, [:server, :metastore])
end
