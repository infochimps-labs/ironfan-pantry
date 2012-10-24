#
# Cookbook Name:: strongswan
# Description:: Installs and launches a StrongSwan server.
# Recipe:: connections
# Author:: Nathaniel Eliot (<temujin9@infochimps.com>)
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

# Make sure this runs after all node[:strongswan][:scenarios] changes.
# FIXME: This actually begs to be a resource, but I don't have enough
#   bandwidth to handle it, and there are only two sources currently.

# Set up the per-scenario connection configurations
available     = "/etc/ipsec.d/conns-available"
enabled       = "/etc/ipsec.d/conns-enabled"
directory available
directory enabled

node[:strongswan][:scenarios].each do |scenario|
  scenario_dir  = "#{available}/#{scenario}"
  directory scenario_dir
  link("#{enabled}/#{scenario}") { to scenario_dir }

  %w{ server.ipsec.conf server.ipsec.secrets
      client.ipsec.conf client.ipsec.secrets }.each do |fname|
    template "#{scenario_dir}/#{fname}" do
      source "#{scenario}/#{fname}.erb"
      notifies :reload, "service[ipsec]", :delayed
    end
  end
end

