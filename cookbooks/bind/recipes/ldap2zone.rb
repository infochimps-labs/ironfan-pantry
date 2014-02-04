#
# Cookbook Name:: bind 
# Recipe:: ldap2zone 
#
# Copyright 2011, Eric G. Wolfe
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

# This is optional code to slurp DNS zones from Active Directory
# integrated domain controllers.  If you have a proper IP address
# management solution, you could replace the code to query an API
# on your IPAM server.
#
# Any query should use the '<<' operator to push results on to the
# node["bind"]["zones"] array.
#
# You can just use an override["bind"]["zones"] in a role or environment
# instead.  Or even a mix of both override, and API query to populate zones.
unless ( node['bind']['ldap']['server'].nil? and node['bind']['ldap']['binddn'].nil? and node['bind']['ldap']['bindpw'].nil? )
  chef_gem "net-ldap" do
    version "0.2.2"
    action :install
  end

  require 'net/ldap'

  ldap = Net::LDAP.new(
    :host => node['bind']['ldap']['server'],
    :auth => {
      :method => :simple,
      :username => node['bind']['ldap']['binddn'],
      :password => node['bind']['ldap']['bindpw']
    }
  )

  if ldap.bind
    ldap.search(
      :base => node['bind']['ldap']['domainzones'],
      :filter => node['bind']['ldap']['filter']) do |dnszone|
      node.default['bind']['zones']['ldap'] << dnszone['name'].first
    end
  else
    Chef::Log.error("LDAP Bind failed with #{node['bind']['ldap']['server']}")
    raise
  end
end
