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

if node[:hadoop][:hive][:install_method] == 'release'
  war_version = node[:hadoop][:hive][:version]
else
  war_version = [node[:hadoop][:hive][:version], node[:apt][:cloudera][:release_name]].map(&:to_s).join('-')
end

template File.join(node[:hadoop][:hive][:conf_dir], 'hive-site.xml') do
  owner "root"
  mode "0644"
  variables(:hive => node[:hadoop][:hive], war_version: war_version)
  source "hive-site.xml.erb"
end
