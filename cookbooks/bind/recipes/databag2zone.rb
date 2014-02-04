#
# Cookbook Name:: bind 
# Recipe:: databag2zone 
#
# Copyright 2012, Eric G. Wolfe
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

if Chef::Config['solo'] && !node['bind']['allow_solo_search']
  Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")
else

  # Search for single zone string in bind data bag
  search(:bind, "zone:*") do |z|
    node.default['bind']['zones']['databag'] << z['zone']
  end

  # Search for zones arrays in bind data bag
  search(:bind, "zones:*") do |z_arr|
    z_arr['zones'].each do |zone|
      node.default['bind']['zones']['databag'] << zone
    end
  end
end
