#
# Cookbook Name::       repo
# Description::         Sets up apt repository sources
# Recipe::              apt_repository
# Author::              Brandon Bell - Infochimps, Inc
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

if platform_family? "debian" then

  include_recipe 'apt'

  # apt_repository "cloudera" do
  #   uri "#{node[:repo][:uri]}/apt"
  #   distribution 'maverick-cdh3u2'
  #   components ["contrib"]
  #   key "#{node[:repo][:key_uri]}"
  # end
  
  apt_repository "#{node['lsb']['codename']}" do
    uri "#{node[:repo][:uri]}/apt"
    distribution "#{node['lsb']['codename']}"
    components ["main"]
    key "#{node[:repo][:key_uri]}"
  end
  
  apt_repository "webupd8-#{node['lsb']['codename']}" do
    uri "#{node[:repo][:uri]}/apt"
    distribution "webupd8-#{node['lsb']['codename']}"
    components ["main"]
    key "#{node[:repo][:key_uri]}"
  end

end
