#
# Cookbook Name::       graphite
# Description::         Carbon
# Recipe::              carbon
# Author::              Heavy Water Software Inc.
#
# Copyright 2011, Heavy Water Software Inc.
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

include_recipe 'runit'
include_recipe 'install_from'

package "python-twisted"

standard_dirs('graphite.carbon'){ directories   :log_dir }

runit_service "graphite_carbon" do
  run_state     node[:graphite][:carbon][:run_state]
  options       Mash.new(:subsys => :carbon).merge(node[:graphite]).merge(node[:graphite][:carbon])
end

announce(:graphite, :carbon,
  :port             => node[:graphite][:carbon][:line_rcvr_port],
  :pickle_rcvr_port => node[:graphite][:carbon][:pickle_rcvr_port],
  :cache_rcvr_port  => node[:graphite][:carbon][:cache_rcvr_port],
  :addr             => private_ip_of(node),
  :pickle_rcvr_addr => private_ip_of(node),
  :cache_rcvr_addr  => private_ip_of(node),
  )
