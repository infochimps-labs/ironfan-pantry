#
# Cookbook Name:: vsphere_utils
# Recipe:: dns
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

template "/etc/resolv.conf" do
  source        "resolv.conf.erb"
  mode          "0644"
end

template "/etc/dns_update.txt" do 
  source 	"dns_update.txt.erb"
  mode		"0600"
  only_if       { node[:vsphere_utils][:dns][:master] }
  notifies      :run, 'execute[nsupdate]', :immediately
end

execute 'nsupdate' do
  command 'nsupdate /etc/dns_update.txt'
  action :nothing
end

ohai "reload" do
  action :reload
end
