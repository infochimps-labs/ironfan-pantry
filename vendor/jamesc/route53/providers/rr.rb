#
# Cookbook Name:: route53
# Provider:: rr
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
include Opscode::Route53::Route53

action :create do
  # Bail if the zone doesn't exist
  zone_id = find_zone_id(new_resource.zone) or raise "Route53 Zone #{new_resource.zone} does not exist"

  rr = resource_record(zone_id, new_resource.fqdn, new_resource.type)
  if rr.nil?
    Chef::Log.info("Route53 Record #{new_resource.fqdn} does not exist, creating. (#{[zone_id, new_resource.fqdn, new_resource.type].inspect})")
    create_resource_record(zone_id, new_resource.fqdn, new_resource.type, new_resource.ttl, new_resource.values)
  else
    Chef::Log.info("Already have #{new_resource.type} Record for #{new_resource.fqdn}, skipping. (#{[zone_id, new_resource.fqdn, new_resource.type].inspect})")
  end
end

action :update do
  # Bail if the zone doesn't exist
  zone_id = find_zone_id(new_resource.zone) or raise "Route53 Zone #{new_resource.zone} does not exist"

  rr = resource_record(zone_id, new_resource.fqdn, new_resource.type)
  if rr.nil?
    Chef::Log.info("Route53 Record #{new_resource.fqdn} does not exist, creating.")
    create_resource_record(zone_id, new_resource.fqdn, new_resource.type, new_resource.ttl, new_resource.values)
  else
    Chef::Log.info("Already have #{new_resource.type} Record for #{new_resource.fqdn}, updating.")
    update_resource_record(zone_id, new_resource.fqdn, new_resource.type, new_resource.ttl, new_resource.values, rr)
  end

end
private

