#
# Cookbook Name:: route53
# Library:: route53
#
# Copyright 2010, Platform14.com.
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

module Opscode
  module Route53
    module Route53

      def route53
        @@route53 ||= Fog::DNS.new(
          :provider => 'AWS',
          :aws_access_key_id     => new_resource.aws_access_key_id,
          :aws_secret_access_key => new_resource.aws_secret_access_key)
      end

      def zones
        route53.zones
      end

      def zone_for_name(zone_name)
        zones.detect{|zone| zone.domain == "#{zone_name}." }
      end

      def zone_for_id(zone_id)
        zones.detect{|zone| zone.id == zone_id }
      end

      def resource_record(zone, fqdn, type)
        zone.records.get(fqdn,type,nil)
      end

      def safely(&block)
        begin
          yield
        rescue StandardError => e
          Chef::Log.warn "Error updating hostname: #{e}"
        end
      end
      module_function :safely

      def update_resource_record(zone, fqdn, type, ttl, values, rr=nil)
        safely do
          Chef::Log.debug(["update_resource_record", fqdn, type, ttl.to_s, values, rr].inspect)
          rr ||= resource_record(zone, fqdn, type)
          if rr.nil?
            create_resource_record(zone, fqdn, type, ttl, values)
          else
            rr.modify(:name => fqdn, :type => type, :ttl => ttl.to_s, :value => values)
            rr.wait_for { ready? }
          end
        end
      end

      def create_resource_record(zone, fqdn, type, ttl, values)
        safely do
          Chef::Log.debug(["create_resource_record", fqdn, type, ttl, values].inspect)
          zone.records.create(:name => fqdn, :type => type, :ttl => ttl.to_s, :value => values)
        end
      end

      def delete_resource_record(zone, fqdn, type, ttl, values)
        safely do
          rr = resource_record(zone, fqdn, type)
          if rr.nil?
            Chef::Log.warn("Tried to delete non-existent record #{fqdn} (#{type} #{values})")
          else
            rr.destroy
          end
        end
      end

    end
  end
end
