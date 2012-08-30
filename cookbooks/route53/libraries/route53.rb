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

  module Fog
    module DNS
      class AWS

        class Record < Fog::Model

          attribute :created_at,  :aliases => ['SubmittedAt']

          def update(new_value, new_ttl)
            Chef::Log.info(["update record model", self].inspect)
            requires :name, :type, :zone
            #
            batch = []
            old_records = zone.records.all!.select{|record| (record.name == self.name) && (record.type == self.type) }
            Chef::Log.info(["update record model", old_records].inspect)
            old_records.each do |record|
              batch << { :action => 'DELETE', :name => record.name, :resource_records => [*record.value], :ttl => record.ttl.to_s, :type => record.type }
            end
            batch << { :action => 'CREATE', :name => name, :resource_records => [*new_value], :ttl => new_ttl.to_s, :type => type }
            #
            Chef::Log.info(batch.inspect)
            data = connection.change_resource_record_sets(zone.id, batch).body
            merge_attributes(data)
            @last_change_id     = data['Id']
            @last_change_status = data['Status']
            [@last_change_id, @last_change_status]
          end

          def wait
            return unless @last_change_id
            while @last_change_status != 'INSYNC'
              sleep 2
              response = connection.get_change(@last_change_id)
              if response.status == 200
                @last_change_id     = response.body['Id']
                @last_change_status = response.body['Status']
              else
                Chef::Log.warn("Bad request: #{response.status} -- #{response}")
              end
              yield(@last_change_id, @last_change_status) if block_given?
            end
          end

        end
      end
    end
  end

rescue LoadError
  Chef::Log.warn("Missing gem 'fog'")
end

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
          Chef::Log.info(["update_resource_record", fqdn, type, ttl.to_s, values, rr].inspect)
          rr ||= resource_record(zone, fqdn, type)
          if rr.nil?
            create_resource_record(zone, fqdn, type, ttl, values)
          else
            rr.update(values, ttl.to_s) && rr.wait{|cid,status| Chef::Log.info("Creating Resource Record for #{fqdn} (#{type}) - #{status}") }
          end
        end
      end

      def create_resource_record(zone, fqdn, type, ttl, values)
        safely do
          Chef::Log.info(["create_resource_record", fqdn, type, ttl, values].inspect)
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
