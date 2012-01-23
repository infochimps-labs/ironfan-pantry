#
# Cookbook Name:: route53
# Recipe:: ec2
#
# Copyright:: 2010, Opscode, Inc <legal@opscode.com>, Platform14.com <jamesc.000@gmail.com>
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

include_recipe 'route53'

# aws = data_bag_item("aws", "route53")
aws = node[:aws]

new_hostname    =  node.name
new_fqdn        = [new_hostname, node[:organization], node[:route53][:zone]].compact.join(".")

# point "datanode-3.gordo.awesomeco.myzone.com" => the ec2.public_hostname
route53_rr(new_hostname) do
  zone          node[:route53][:zone]

  fqdn          new_fqdn
  type          "CNAME"
  values        ["#{node[:ec2][:public_hostname]}."]

  action        :create
  aws_access_key_id     aws["aws_access_key_id"]
  aws_secret_access_key aws["aws_secret_access_key"]
end

# node.automatic_attrs["hostname"] = new_hostname
# node.automatic_attrs["fqdn"]     = new_fqdn
#
# ruby_block "edit etc hosts" do
#   block do
#     rc = Chef::Util::FileEdit.new("/etc/hosts")
#     rc.search_file_replace_line(
#       /^127\.0\.0\.1(.*)localhost.localdomain localhost$/,
#        "127.0.0.1 #{new_hostname} #{new_fqdn} \\1 localhost")
#     rc.write_file
#   end
# end
#
# execute("hostname --file /etc/hostname"){ action(:nothing) }
# file "/etc/hostname" do
#   content       new_fqdn
#   notifies      :run, resources(:execute => "hostname --file /etc/hostname"), :immediately
# end

# service "network" do
#   supports      :status => true, :restart => true, :reload => true
#   action        :nothing
# end
#
# template "/etc/dhcp/dhclient.conf" do
#   source        "dhclient.conf.erb"
#   owner         "root"
#   group         "root"
#   mode          0644
#   notifies      :restart, resources(:service => "network"), :immediately
# end
