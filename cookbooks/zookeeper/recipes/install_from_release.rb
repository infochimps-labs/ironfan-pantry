#
# Cookbook Name::       zookeeper
# Description::         Install from the release tarball.
# Recipe::              install_from_release
# Author::              Travis Dempsey - Infochimps, Inc
#
# Copyright 2009, Infochimps, Inc.
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

include_recipe       'zookeeper'
include_recipe       'ant'
include_recipe       'install_from'

package 'ivy'        if platform?('ubuntu')
package 'subversion' if platform?('centos')

#
# Install zookeeper from latest release
#
#   puts zookeeper tarball into /usr/local/src/zookeeper-xxx
#   expands it into /usr/lib/zookeeper-xxx
#   and links that to /usr/local/share/zookeeper
#

Chef::Log.info "Zookeeper release url #{node[:release_url]}"
install_from_release('zookeeper') do
  release_url        node[:zookeeper][:release_url]
  home_dir           node[:zookeeper][:home_dir]
  version            node[:zookeeper][:version]
  action             [:build_with_ant, :install]
  environment('JAVA_HOME' => node[:java][:java_home]) if node[:java][:java_home]

  not_if{ ::File.exists?("#{node[:zookeeper][:home_dir]}/zookeeper.jar") }
end
