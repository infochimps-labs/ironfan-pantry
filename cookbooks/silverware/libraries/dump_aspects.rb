module Ironfan
  module Discovery
    module_function

    def dump_aspects(run_context)
      [
        [:apache,         :server],
        [:cassandra,      :server],
        [:chef,           :client],
        [:chef,           :server],
        [:cron,           :daemon],
        [:elasticsearch,  :server],
        [:flume,          :agent],
        [:flume,          :master],
        [:ganglia,        :master],
        [:ganglia,        :monitor],
        [:graphite,       :carbon],
        [:graphite,       :dashboard],
        [:graphite,       :whisper],
        #
        [:hadoop,         :datanode],
        [:hadoop,         :hdfs_fuse],
        [:hadoop,         :jobtracker],
        [:hadoop,         :namenode],
        [:hadoop,         :secondarynn],
        [:hadoop,         :tasktracker],
        #
        [:hbase,          :master],
        [:hbase,          :regionserver],
        [:hbase,          :thrift],
        [:hbase,          :stargate],
        #
        [:jenkins,        :server],
        [:jenkins,        :worker],
        [:minidash,       :dashboard],
        [:mongodb,        :server],
        [:mysql,          :server],
        [:nfs,            :server],
        [:nginx,          :server],
        [:ntp,            :server],
        [:redis,          :server],
        [:resque,         :redis],
        [:resque,         :dashboard],
        [:ssh,            :daemon],
        [:statsd,         :server],
        [:zabbix,         :agent],
        [:zabbix,         :master],
        [:zookeeper,      :server],

        # [:goliath,        :app],
        # [:unicorn,        :app],
        # [:apt,            :cacher],
        # [:bluepill,       :monitor],
        # [:resque,         :worker],

      ].each do |sys, subsys|
        components = discover_all(sys, subsys)
        pad = ([""]*20)
        components.each do |component|
          dump_line = dump(component) || []
          puts( "%-15s\t%-15s\t%-23s\t| %-51s\t| %-12s\t#{"%-7s\t"*12}" % [sys, subsys, dump_line, pad].flatten )
        end
      end

      run_context.resource_collection.select{|r| r.resource_name.to_s == 'service' }.each{|r| p [r.name, r.action] }
    end


    def dump(component)
      return if component.empty?
      vals = [
        component.daemon    .map{|asp|  asp.name                }.join(",")[0..20],
        component.port      .map{|asp| "#{asp.flavor}=#{asp.port_num}" }.join(","),
        component.dashboard .map{|asp|  asp.name                }.join(","),
        component.log       .map{|asp|  asp.name                }.join(","),
        DirectoryAspect::ALLOWED_FLAVORS.map do |flavor|
          asp = component[:directory ].detect{|asp| asp[:flavor] == flavor }
          # asp ? "#{asp.flavor}=#{asp.path}" : ""
          asp ? asp.name : ""
        end,
        ExportedAspect::ALLOWED_FLAVORS.map do |flavor|
          asp = component[:exported ].detect{|asp| asp[:flavor] == flavor }
          # asp ? "#{asp.flavor}=#{asp.files.join(",")}" : ""
          asp ? asp.name : ""
        end,
      ]
      vals
    end

  end
end
