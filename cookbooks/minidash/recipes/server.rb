#
# Cookbook Name::       minidash
# Description::         Lightweight thttpd server to render minidash dashboards
# Recipe::              server
# Author::              Philip (flip) Kromer - Infochimps, Inc
#
# Copyright 2011, Philip (flip) Kromer - Infochimps, Inc
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

include_recipe 'minidash'
include_recipe 'runit'

#
# Lightweight THTTPD server
#

case node.platform
when 'centos', 'redhat'
  package       'busybox'
else
  package       'busybox-static'
end

runit_service "minidash_dashboard" do
  run_state     node[:minidash][:run_state]
  options       node[:minidash]
end

link "#{node[:minidash][:log_dir]}/current" do
  to "#{node[:minidash][:home_dir]}/thttpd-dashboard.log"
end
