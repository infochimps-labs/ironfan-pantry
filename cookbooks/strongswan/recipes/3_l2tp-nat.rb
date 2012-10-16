#
# Cookbook Name:: strongswan
# Description:: Installs l2tp ipsec support for StrongSwan server.
# Recipe:: 3_l2tp-nat
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

include_recipe "strongswan::2_service-ipsec"
include_recipe "strongswan::2_service-xl2tpd"

# manipulate various config files to do our bidding
template( "/etc/xl2tpd/xl2tpd.conf" ) do
  source "l2tp-nat/xl2tpd.conf.erb"
end

%w{ options.xl2tpd chap-secrets }.each do |fname|
  template "/etc/ppp/#{fname}" do
    source "l2tp-nat/#{fname}.erb"
  end
end

client_dir = "#{node[:strongswan][:client][:conf_dir]}/l2tp-nat"
directory client_dir do
  recursive true
end

%w{ ipsec.conf ipsec.secrets }.each do |fname|
  template "#{client_dir}/#{fname}" do
    source "l2tp-nat/client.#{fname}.erb"
  end
end
