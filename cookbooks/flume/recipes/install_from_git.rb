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
include_recipe 'maven'

#
# install into eg. /usr/local/share/flume-git
#

git node[:flume][:deploy_dir] do
  repository    node[:flume][:deploy_url]
  revision      "branch-#{node[:flume][:version]}"
  action        :sync
  user          'root'
end

#
# build with maven
#

bash "build flume #{node[:flume][:version]} with maven" do
  user          'root'
  cwd           node[:flume][:deploy_dir]
  code          "mvn package -D skipTests"
  environment   'THRIFT_HOME' => node[:thrift][:prefix_root]
end

link node[:flume][:home_dir] do
  to            File.join(node[:flume][:deploy_dir], "flume-distribution/target/flume-distribution-#{node[:flume][:version]}-SNAPSHOT-bin/flume-#{node[:flume][:version]}-SNAPSHOT")
  action        :create
end

#
# make directories
#

standard_dirs('flume') do
  directories [:conf_dir, :pid_dir]
end

#
# link in artifacts
#

directory(File.dirname(node[:flume][:conf_dir])){ action :create }
link node[:flume][:conf_dir] do
  to            File.join(node[:flume][:home_dir], 'conf')
  action        :create
end

file File.join(node[:flume][:prefix_root], 'bin', 'flume') do
  content       %Q{#!/bin/sh \nexec #{node[:flume][:home_dir]}/bin/flume "$@"\n}
  mode          '0755'
end

# TODO:
# * /var/lib/alternatives/flume-conf
# * /usr/share/man/man1
# * /usr/share/doc
# * /etc/alternatives/flume-conf
