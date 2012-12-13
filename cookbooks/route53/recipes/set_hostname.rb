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

if aws && aws[:aws_access_key_id] && aws[:aws_secret_access_key] && node[:cloud]

  node_name   = (node[:route53][:node_name] || node.name).to_s

  hostname    =  node_name.gsub(/[^a-zA-Z0-9\-]/, '-')
  fqdn        = [hostname, node[:route53][:zone]].compact.join(".")

  # point "gordo-datanode-3.awesomeco.com" => the cloud hostname
  route53_rr(hostname) do
    zone          node[:route53][:zone]

    fqdn          fqdn
    type          "CNAME"
    values        ["#{node[:cloud][:public_hostname]}."]
    ttl           node[:route53][:ttl]

    action        :update
    aws_access_key_id     aws[:aws_access_key_id]
    aws_secret_access_key aws[:aws_secret_access_key]
  end
  node.set[:route53][:fqdn] = fqdn
elsif not node[:cloud]
  Chef::Log.warn("Cannot set hostname, because the node[:cloud] attributes aren't set. On a cloud machine, sometimes this doesn't happen until the second run.")
else
  Chef::Log.warn("Cannot set hostname, because we have no AWS credentials: set node[:aws][:aws_access_key_id] and node[:aws][:aws_secret_access_key]")
end
