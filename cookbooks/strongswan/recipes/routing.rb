#
# Cookbook Name:: strongswan
# Description:: Installs local NAT routing support for StrongSwan server.
# Recipe:: routing
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

# FIXME: This is actually a whole separate concern from StrongSwan, and
#   deserves its own cookbook.

# Set up IPv4 packet forwarding
execute "ipv4_forwarding" do
  command "echo 1 > /proc/sys/net/ipv4/ip_forward"
  action :nothing
end

template( "/etc/sysctl.conf" ) do
  source "routing/sysctl.conf.erb"
  notifies :run, 'execute[ipv4_forwarding]', :delayed
end

# Add iptables masquerading rule
execute 'iptables_masquerade' do
  command "iptables --table nat --append POSTROUTING --source #{node[:strongswan][:ipsec][:local][:subnet]} -j MASQUERADE"
  action :nothing
end

template( "/etc/rc.local" ) do
  source "routing/rc.local.erb"
  notifies :run, 'execute[iptables_masquerade]', :delayed
end
