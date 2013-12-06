#
# Cookbook Name::       impala
# Description::         Add Cloudera repo to package manager
# Recipe::              add_cloudera_repo
# Author::              Erik Mackdanz - Infochimps, Inc
#
# Copyright 2013, Erik Mackdanz - Infochimps, Inc
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
when 'ubuntu'
  include_recipe 'apt'

  if node[:apt][:cloudera][:force_distro] != node[:lsb][:codename]
    Chef::Log.info "Forcing cloudera distro to '#{node[:apt][:cloudera][:force_distro]}' (your machine is '#{node[:lsb][:codename]}')"
  end

  # Add cloudera package repo, deleting an existing one first
  apt_repository 'cloudera-impala' do
    action          :remove
  end

  apt_repository 'cloudera-impala' do
    distro          = node[:apt][:cloudera][:force_distro] || node[:lsb][:codename] # only lucid or precise
    uri             "http://archive.cloudera.com/impala/ubuntu/#{distro}/amd64/impala"
    distribution    "#{distro}-impala1.1.1"
    components      ['contrib']
    key             "http://archive.cloudera.com/impala/ubuntu/precise/amd64/impala/archive.key"
    arch            'amd64'
    action          :add
  end
end
