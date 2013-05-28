#
# Cookbook Name::       repo
# Description::         Sets up apt repository
# Recipe::              gem
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

gem_package 'rubygems-mirror'

directory node[:repo][:gem][:base] do
  owner	"root"
  group	"root"
  mode	0755
  action :create
end

template "/root/.gem/.mirrorrc" do
  source "gem.mirrorrc.erb"
  mode 0644
end

cron "gem sync" do
  minute        node[:repo][:gem][:minute]
  hour          node[:repo][:gem][:hour]
  day           node[:repo][:gem][:day]
  month         node[:repo][:gem][:month]
  weekday       node[:repo][:gem][:weekday]
  command       "/usr/local/sbin/gem mirror > /tmp/ruby-gem-mirror.out 2>&1; gem generate_index --update -d #{node[:repo][:gem][:base]}"
end
