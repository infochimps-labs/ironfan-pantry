#
# Cookbook Name:: vsphere_utils
# Recipe:: hostname
#
# Copyright 2013, Infochimps, Inc
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

fqdn = "#{node[:node_name]}.#{node[:vsphere_utils][:domain]}"

if node[:hostname] != fqdn
  execute "hostname #{fqdn}"
end

file "/etc/hostname" do
  action :create_if_missing
  mode 0644
  content fqdn
end

ohai "reload" do
  action :reload
end
