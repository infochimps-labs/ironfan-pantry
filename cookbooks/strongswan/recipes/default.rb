#
# Cookbook Name:: strongswan
# Description:: Installs and launches a StrongSwan server.
# Recipe:: default
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
package( "strongswan-ikev1" ){ action :nothing }.run_action(:install)
package( "strongswan-ikev2" ){ action :nothing }.run_action(:install)

directory '/etc/ipsec.d/client'
directory '/etc/ipsec.d/client/nat-rw-psk'

%w{ ipsec.conf ipsec.secrets }.each do |fname|
	template "/etc/ipsec.d/client/nat-rw-psk/#{fname}" do
		source "nat-rw-psk/#{fname}.erb"
	end
end
