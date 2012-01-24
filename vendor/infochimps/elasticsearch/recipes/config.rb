#
# Cookbook Name::       elasticsearch
# Description::         configuration files for elasticsearch
# Recipe::              default
# Author::              GoTime, modifications by Infochimps
#
# Copyright 2010, GoTime
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

template "/etc/elasticsearch/logging.yml" do
  source        "logging.yml.erb"
  mode          0644
end

template "/etc/elasticsearch/elasticsearch.in.sh" do
  source        "elasticsearch.in.sh.erb"
  mode          0644
  variables     :elasticsearch => node[:elasticsearch]
end

node[:elasticsearch][:seeds] = discover_all(:elasticsearch, :datanode).map(&:private_ip)
p "WARNING: No seeds!" if node[:elasticsearch][:seeds].empty?
p node[:elasticsearch][:seeds] unless node[:elasticsearch][:seeds].empty?
template "/etc/elasticsearch/elasticsearch.yml" do
  source        "elasticsearch.yml.erb"
  owner         "elasticsearch"
  group         "elasticsearch"
  mode          0644
  variables     ({
    :elasticsearch      => node[:elasticsearch],
    :aws                => node[:aws]
  })
end
