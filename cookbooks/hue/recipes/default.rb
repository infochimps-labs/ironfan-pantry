#
# Cookbook Name::       hue
# Description::         Base configuration for hue
# Recipe::              default
# Author::              Philip (flip) Kromer - Infochimps, Inc
#
# Copyright 2009, Opscode, Inc.
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

daemon_user :hue

group 'hadoop' do
  gid         node[:groups]['hadoop'][:gid]
  action      [:create, :manage]
  append      true
  members     ['hue']
end

group 'supergroup' do
  gid         node[:groups]['supergroup'][:gid]
  action      [:create, :manage]
  append      true
  members     ['hue']
end

standard_dirs('hue') do
  directories   :conf_dir
end


# Hive log storage on a single scratch dir
volume_dirs('hive.log') do
  type          :local
  selects       :single
  path          'hue/log'
  group         'hadoop'
  mode          "0777"
end
link "/var/log/hue" do
  to node[:hue][:log_dir]
end

