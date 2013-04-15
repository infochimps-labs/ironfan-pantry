#
# Cookbook Name::       flume
# Description::         Install flume using designated git repo and branch
# Recipe::              install_from_git
# Author::              Chris Howe - Infochimps, Inc
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

include_recipe 'flume::default'

#
# install into eg. /usr/local/share/flume-git
#

install_from_release(:flume) do
  release_url   node[:flume][:release_url]
  version       node[:flume][:version]
  home_dir      node[:flume][:home_dir]
  action        :install
end

directory(File.dirname(node[:flume][:conf_dir])){ action :create }
link node[:flume][:conf_dir] do
  to            File.join(node[:flume][:home_dir], 'conf')
  action        :create
end

file File.join(node[:flume][:prefix_root], 'bin', 'flume') do
  content       %Q{#!/bin/sh \nexec #{node[:flume][:home_dir]}/bin/flume "$@"\n}
  mode          '0755'
end
