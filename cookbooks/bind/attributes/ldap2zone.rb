#
# Cookbook Name:: bind 
# Attributes:: ldap2zone 
#
# Copyright 2011, Eric G. Wolfe 
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Specific variables for slurping zone names right out of Active Directory, or LDAP 
default['bind']['ldap']['binddn'] = nil
default['bind']['ldap']['bindpw'] = nil
default['bind']['ldap']['filter'] = "(&(!(name=RootDNSServers))(objectClass=dnsZone))"
default['bind']['ldap']['server'] = nil 
default['bind']['ldap']['domainzones'] = "cn=MicrosoftDNS,dc=DomainDnsZones,dc=example,dc=com"
