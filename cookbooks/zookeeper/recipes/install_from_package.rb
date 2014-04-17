#
# Cookbook Name::       zookeeper
# Description::         Installs Zookeeper from the cloudera package -- verified compatible, but on a slow update schedule.
# Recipe::              install_from_package
# Author::              Travis Dempsey - Infochimps, Inc
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

include_recipe 'zookeeper'
include_recipe 'hadoop::add_cloudera_repo'

package 'zookeeper' do
  version            node[:zookeeper][:version]
end
