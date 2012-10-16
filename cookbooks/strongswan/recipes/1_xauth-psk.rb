#
# Cookbook Name:: strongswan
# Description:: Installs and launches a StrongSwan server.
# Recipe:: 1_xauth-psk
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

include_recipe "strongswan::default"
include_recipe "strongswan::2_service-ipsec"

announce( :strongswan, :server )

# manipulate config files to do our bidding
%w{ ipsec.conf ipsec.secrets strongswan.conf }.each do |fname|
  template "/etc/#{fname}" do
    source "xauth-psk/#{fname}.erb"
  end
end

directory '/etc/ipsec.d/client'
directory '/etc/ipsec.d/client/xauth-psk'

%w{ ipsec.conf ipsec.secrets }.each do |fname|
  template "/etc/ipsec.d/client/xauth-psk/#{fname}" do
    source "xauth-id-psk-config/client.#{fname}.erb"
  end
end
