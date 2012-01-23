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

begin
  require 'fog'
rescue LoadError
  Chef::Log.warn("Missing gem 'fog'")
end

module Opscode
  module Route53
    module Route53

      def find_zone_id(zone_name="")
        zone_id  = nil
        options  = { :max_items => 200 }
        response = route53.list_hosted_zones(options)
        return unless (response.status == 200)
        #
        zones = response.body['HostedZones']
        zones.each do |zone|
          domain_name  = zone['Name']
          if domain_name.chop == zone_name
            zone_id = zone['Id'].sub('/hostedzone/', '')
          end
        end
        zone_id
      end

      def resource_record(zone_id, fqdn, type)
        rr = nil
        options = { :max_items => 100, :name => "platform14.net.", :type => type}
        response = route53.list_resource_record_sets(zone_id, options)
        return unless (response.status == 200)
        #
        records = response.body['ResourceRecordSets']
        records.each do |record|
          Chef::Log.debug("Record : #{record}")
          record_name = record['Name']
          rr = record if (record_name.chop == fqdn) && (record['Type'] == type)
        end
        rr
      end

      def update_resource_record(zone_id, fqdn, type, ttl, values, rr=nil)
        rr ||= resource_record(zone_id, fqdn, type)

        # Create if it doesn't exising in route53 already
        if rr.nil?
          create_resource_record(zone_id, fqdn, type, ttl, values)
        else

        end
      end

      def create_resource_record(zone_id, fqdn, type, ttl, values )
        record = { :name => fqdn, :type => type, :ttl => 3600, :resource_records => values, :action => "CREATE" }
        #
        change_batch = [record]
        options      = { :comment => "Change #{type} record for #{fqdn}"}
        response     = route53.change_resource_record_sets( zone_id, change_batch, options)
        #
        if response.status == 200
          change_id  = response.body['Id']
          status     = response.body['Status']
        end

        #wait until new zone is live across all name servers
        while status == 'PENDING'
          sleep 2
          response    = route53.get_change(change_id)
          if response.status == 200
            change_id = response.body['Id']
            status    = response.body['Status']
          end
          Chef::Log.info("Creating Resource Record for  #{fqdn} (#{type}) - #{status}")
        end
      end

      def route53
        @@route53 ||= Fog::DNS.new(
          :provider => 'AWS',
          :aws_access_key_id     => new_resource.aws_access_key_id,
          :aws_secret_access_key => new_resource.aws_secret_access_key)
      end
    end
  end
end
