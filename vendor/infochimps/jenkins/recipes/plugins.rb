#
# Cookbook Name::       jenkins
# Description::         Server
# Recipe::              server
# Author::              Doug MacEachern <dougm@vmware.com>
#
# Copyright 2010, VMware, Inc.
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

plugins_dir = File.join(node[:jenkins][:server][:home_dir], 'plugins')

directory plugins_dir do
  owner         node[:jenkins][:server][:user]
  group         node[:jenkins][:server][:group]
  not_if{ node[:jenkins][:server][:plugins].empty? }
end

node[:jenkins][:server][:plugins].each do |name|
  plugin_file = File.join(plugins_dir, "#{name}.hpi")
  remote_file plugin_file do
    source      "#{node[:jenkins][:plugins_mirror]}/latest/#{name}.hpi"
    backup      false
    owner       node[:jenkins][:server][:user]
    group       node[:jenkins][:server][:group]
    mode        "0644"
    notifies    :restart, 'service[jenkins_server]' if startable?(node[:jenkins][:server])
    not_if{ File.exists?(plugin_file) }
  end
end
