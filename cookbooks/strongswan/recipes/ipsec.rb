#
# Cookbook Name:: strongswan
# Description:: Installs and launches a StrongSwan server.
# Recipe:: ipsec
# Author:: Jerry Jackson (<jerry.w.jackson@gmail.com>)
#
# Copyright 2012, Infochimps
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

# install strongswan from package
package "strongswan-ikev1"      # the old pluto daemon
package "strongswan-ikev2"      # the new charon daemon
# Note: future versions will use the charon daemon only; watch out for
#   changed package names and configuration formats on upgrade

# package( "strongswan-ikev1" ){ action :nothing }.run_action(:install)
# package( "strongswan-ikev2" ){ action :nothing }.run_action(:install)

# ipsec service definition
service "ipsec" do
  service_name node[:strongswan][:ipsec][:service_name]
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
end

announce( :strongswan, :ipsec )

scenario = node[:strongswan][:scenario]

# manipulate config files to do our bidding
%w{ ipsec.conf ipsec.secrets strongswan.conf }.each do |fname|
  template "/etc/#{fname}" do
    source "#{scenario}/#{fname}.erb"
    notifies :reload, "service[ipsec]", :delayed
  end
end

client_dir = "#{node[:strongswan][:client][:conf_dir]}/#{scenario}"
directory client_dir do
  recursive true
end

%w{ ipsec.conf ipsec.secrets }.each do |fname|
  template "#{client_dir}/#{fname}" do
    source "#{scenario}/client.#{fname}.erb"
  end
end
