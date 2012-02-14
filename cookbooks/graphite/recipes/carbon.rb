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

include_recipe "runit"
include_recipe 'install_from'

package "python-twisted"

carbon_dir = node[:graphite][:carbon][:home_dir] || "/usr/local/share/carbon"

install_from_release('carbon') do
  version       node[:graphite][:carbon][:version]
  release_url   node[:graphite][:carbon][:release_url]
  home_dir      node[:graphite][:carbon][:home_dir]
  checksum      node[:graphite][:carbon][:release_url_checksum]
  action        [:install_python]
  not_if{ File.exists?("/usr/local/lib/python2.6/dist-packages/carbon-#{node[:graphite][:carbon][:version]}.egg-info") }
end

# execute "install carbon" do
#   command "python setup.py install"
#   creates "/opt/graphite/lib/carbon-#{node[:graphite][:carbon][:version]}-py2.6.egg-info"
#   cwd "/usr/src/carbon-#{node[:graphite][:carbon][:version]}"
# end

template "#{node[:graphite][:conf_dir]}/carbon.conf" do
  variables( :storage_dir      => node[:graphite][:data_dir],
             :line_rcvr_addr   => node[:graphite][:carbon][:line_rcvr_addr],
             :pickle_rcvr_addr => node[:graphite][:carbon][:pickle_rcvr_addr],
             :cache_query_addr => node[:graphite][:carbon][:cache_query_addr] )
  notifies :restart, "service[carbon-cache]", :delayed if startable?(node[:graphite][:carbon])
end

template "#{node[:graphite][:conf_dir]}/storage-schemas.conf"

template "/etc/init.d/carbon-cache" do
  source "init.d_carbon-cache.erb"
  mode 0755
  variables :carbon_dir => carbon_dir
end

# # execute "setup carbon sysvinit script" do
# #   command "ln -nsf /opt/graphite/bin/carbon-cache.py /etc/init.d/carbon-cache"
# #   creates "/etc/init.d/carbon-cache"
# # end
#
# service "carbon-cache" do
# #   running true
# #   start_command "/opt/graphite/bin/carbon-cache.py start"
# #   stop_command "/opt/graphite/bin/carbon-cache.py stop"
#   action [ :enable, :start ]
# #   action :start
# end
