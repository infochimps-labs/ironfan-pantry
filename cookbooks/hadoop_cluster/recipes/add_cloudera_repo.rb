#
# Cookbook Name::       hadoop_cluster
# Description::         Add Cloudera repo to package manager
# Recipe::              add_cloudera_repo
# Author::              Chris Howe - Infochimps, Inc
#
# Copyright 2011, Chris Howe - Infochimps, Inc
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

case node[:platform]
when 'centos', 'redhat'
  include_recipe 'yum'
  execute "yum clean all" do
    action :nothing
  end

  yum_key node[:yum][:cloudera][:gpg_keyname] do
    url node[:yum][:cloudera][:gpg_key]
    action:add
  end

  yum_repository "cloudera" do
    description "Cloudera distribution for #{node[:yum][:cloudera][:release_name]}"
    name node[:yum][:cloudera][:release_name] 
    key node[:yum][:cloudera][:gpg_keyname]
    url node[:yum][:cloudera][:mirror_list]
    mirrorlist true
    action :add
  end

when 'ubuntu'
  include_recipe 'apt'

  if node[:apt][:cloudera][:force_distro] != node[:lsb][:codename]
    Chef::Log.info "Forcing cloudera distro to '#{node[:apt][:cloudera][:force_distro]}' (your machine is '#{node[:lsb][:codename]}')"
  end

  # Add cloudera package repo
  apt_repository 'cloudera' do
    uri             'http://archive.cloudera.com/debian'
    distro        = node[:apt][:cloudera][:force_distro] || node[:lsb][:codename]
    distribution    "#{distro}-#{node[:apt][:cloudera][:release_name]}"
    components      ['contrib']
    key             "http://archive.cloudera.com/debian/archive.key"
    action          :add
  end
end
