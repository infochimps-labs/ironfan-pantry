#
# Cookbook Name::       flume
# Description::         Finalizes the config, writes out the config files
# Recipe::              config
# Author::              Philip (flip) Kromer - Infochimps, Inc
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

[:flume, :hadoop, :hbase, :zookeeper, :jruby].each do |component|
  next unless node[component]
  Chef::Log.info( [ component, node[component][:exported_jars] ].inspect )
  Array(node[component][:exported_jars]).flatten.each do |export|
    link "#{node[:flume][:home_dir]}/lib/#{File.basename(export)}" do
      to  export
    end
  end
  Array(node[component][:exported_confs]).flatten.each do |export|
    link "#{node[:flume][:conf_dir]}/#{File.basename(export)}" do
      to  export
    end
  end
end
