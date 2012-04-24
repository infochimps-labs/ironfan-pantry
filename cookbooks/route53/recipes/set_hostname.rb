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

require 'fog'
load File.expand_path('../libraries/fog_monkeypatch.rb', File.dirname(__FILE__))

# aws = data_bag_item("aws", "route53")
aws = node[:aws]

if aws && aws[:aws_access_key_id] && aws[:aws_secret_access_key]

  public_hostname    =  node.name
  public_fqdn        = [public_hostname, node[:route53][:zone]].compact.join(".")
  case
  when node[:cloud] then machine_public = node[:cloud][:public_hostname] ; machine_private = node[:cloud][:local_hostname]
  when node[:ec2]   then machine_public = node[:ec2  ][:public_hostname] ; machine_private = node[:ec2  ][:local_hostname]
  else                   machine_public = machine_private = node[:fqdn] ; Chef::Log.warn("Can't reliably detect public hostname, going with public = private = #{machine_public}")
  end

  # point "gordo-datanode-3.awesomeco.com" => the cloud public_hostname
  route53_rr(public_hostname) do
    zone          node[:route53][:zone]

    fqdn          public_fqdn
    type          "CNAME"
    values        ["#{machine_public}."]
    ttl           node[:route53][:ttl]

    action        :update
    aws_access_key_id     aws[:aws_access_key_id]
    aws_secret_access_key aws[:aws_secret_access_key]
  end

  private_hostname    =  "#{node.name}-internal"
  private_fqdn        = [private_hostname, node[:route53][:zone]].compact.join(".")

  # point "gordo-datanode-3-internal.awesomeco.com" => the cloud local_hostname
  route53_rr(private_hostname) do
    zone          node[:route53][:zone]

    fqdn          private_fqdn
    type          "CNAME"
    values        ["#{machine_private}."]
    ttl           node[:route53][:ttl]

    action        :update
    aws_access_key_id     aws[:aws_access_key_id]
    aws_secret_access_key aws[:aws_secret_access_key]
  end

  # node.automatic_attrs["hostname"] = private_hostname
  # node.automatic_attrs["fqdn"]     = private_fqdn
  #
  # ruby_block "edit etc hosts" do
  #   block do
  #     rc = Chef::Util::FileEdit.new("/etc/hosts")
  #     rc.search_file_replace_line(
  #       /^127\.0\.0\.1(.*)localhost.localdomain localhost$/,
  #        "127.0.0.1 #{private_hostname} #{private_fqdn} \\1 localhost")
  #     rc.write_file
  #   end
  # end
  #
  # execute("hostname --file /etc/hostname"){ action(:nothing) }
  # file "/etc/hostname" do
  #   content       private_fqdn
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

else
  Chef::Log.warn("Cannot set hostname, because we have no AWS credentials: set node[:aws][:aws_access_key_id] and node[:aws][:aws_secret_access_key]")
end
