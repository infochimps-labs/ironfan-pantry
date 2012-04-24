begin
  require 'fog'

  module ::Fog
    class Model ; end
    module DNS
      class AWS
        class Record < ::Fog::Model

          attribute :created_at,  :aliases => ['SubmittedAt']

          def update(new_value, new_ttl)
            Chef::Log.info(["update record model", self].inspect)
            requires :name, :type, :zone
            #
            batch = []
            old_records = zone.records.select{|record| (record.name == self.name) && (record.type == self.type) }
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
