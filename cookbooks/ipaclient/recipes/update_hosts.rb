#
# Cookbook Name:: ipaclient
# Recipe:: update_hosts
#
# Copyright 2014, Infochimps, a CSC Big Data Business
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
# Lifted from
# http://www.onepwr.org/2012/04/26/chef-recipe-to-setup-up-a-new-nodes-fqdn-hostname-etc-properly/
# but I messed around with the actual hostname

#Knife invocations supply FQDN as the node name at creation time and this becomes hostname( option -N)
 
execute "Configure Hostname" do
  command "hostname --file /etc/hostname"
  action :nothing
end
 
#Set the hostname
file "/etc/hostname" do
  content node.name.gsub("_","-") + "-" + node.organization
  notifies :run, resources(:execute => "Configure Hostname"), :immediately
end
 
#This sets up script which will run whenever eth0 comes up(after reboot) to update /etc/hosts
cookbook_file "/etc/network/if-up.d/update_hosts" do
        source "update_hosts.sh"
        owner "root"
        group "root"
        mode 0555
        backup false
end
 
#This sets up a script which will add the master IPA server to hosts
cookbook_file "/etc/network/if-up.d/update_master.sh" do
        source "update_master.sh"
        owner "root"
        group "root"
        mode 0555
        backup false
end

#Execute this script now (firsttime) to set /etc/hosts to have the newly provisioned nodes address/hostname line
bash "update_hosts" do
  user "root"
  group "root"
  cwd "/tmp"
  code <<-EOH
  export IFACE=eth0
  /etc/network/if-up.d/update_hosts "#{node.default['ipaclient']['domain']}"
  /etc/network/if-up.d/update_master.sh "#{node.default['ipaclient']['masterhostname']}.#{node.default['ipaclient']['domain']}"
  EOH
end
