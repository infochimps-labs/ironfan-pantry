define :run_contrib_app, app_type: nil, options: nil, daemon_count: nil, group_id: nil, topic: nil, run_state: nil, user: nil, kafka_home: nil, config_file_options: nil do

  app_type                   = params[:app_type]
  app_name                   = params[:name]
  group_id                   = params[:group_id]  || node[:kafka][:contrib][:app][:group_id]
  group_id_str               = "#{app_name}-group-#{group_id}"
  hadoop_home                = node[:hadoop][:home_dir]
  kafka                      = discover_all(:kafka, :server)
  kafka_port                 = node[:kafka][:port]
  kafka_home                 = params[:kafka_home] || node[:kafka][:home_dir]
  zookeeper_pairs            = discover_all(:zookeeper, :server).map{ |znode| "#{znode.private_ip}:#{znode.ports[:client_port][:port]}" }.join(',')
  hashed_options             = (params[:config_file_options]  || node[:kafka][:contrib][:app][:config_file_options])
  app_options                = (params[:options]  || node[:kafka][:contrib][:app][:options]).map{ |name, value| "--#{name}=#{value}" }.join(' ')
  app_run_state              = params[:run_state] || node[:kafka][:contrib][:app][:run_state]
  topic                      = params[:topic]     || node[:kafka][:contrib][:app][:topic]
  run_as_user                = (params[:user]     || node[:kafka][:contrib][:default_app_user])
  vcd_tmp                    = discover(:vayacondios, :server)
  vayacondios_host           = (vcd_tmp && vcd_tmp.private_ip)
  vayacondios_port           = (vcd_tmp && ((vcd_tmp.ports[:nginx] && vcd_tmp.ports[:nginx][:port]) ||
                                            (vcd_tmp.ports[:goliath] && vcd_tmp.ports[:goliath][:port])))

  Chef::Log.info "Creating config file for Kafka-contrib project #{app_name} (#{app_type})"
  template File.join(node[:kafka][:contrib][:deploy][:root], "current/config/#{app_name}.properties") do
    mode                     '0644'
    source                   "#{app_type}.properties.erb"
    action                   :create

    def hadoop_hdfs_host
      if discover(:hadoop, :jobtracker)
        host = "ip-#{discover(:hadoop, :jobtracker).private_ip.gsub('.', '-')}.ec2.internal"
      elsif discover(:hadoop, :namenode)
        host = discover(:hadoop, :namenode).private_ip
      else
        host = "localhost"
      end
      host
    end

    variables({
      hadoop_hdfs_host:       hadoop_hdfs_host,
      hashed_options:         hashed_options,
      kafka:                  kafka,
      kafka_port:             kafka_port,
      zookeeper:              zookeeper_pairs,
      group_id:               group_id,
      app_name:               app_name,
      topic:                  topic,
      vayacondios_host:       vayacondios_host,
      vayacondios_port:       vayacondios_port,
    })
  end

  # Create the base Kafka Contrib log directory
  directory node[:kafka][:contrib][:log_dir] do
    action                   :create
  end

  log_monitor_info           = {}
  daemon_monitor_info        = {}
  daemons                    = params[:daemon_count] || node[:kafka][:contrib][:app][:daemon_count] || 1
  
  daemons.times do |index|
    app_name_with_index      = "#{app_name}-#{index}"
    indexed_log_dir          = File.join(node[:kafka][:contrib][:log_dir], app_name_with_index)
    log_monitor_info.merge!(app_name_with_index.to_sym => File.join(indexed_log_dir,'current'))
    daemon_monitor_info.merge!(app_name_with_index.to_sym => { service: "kafka_#{app_name_with_index}" })
    
    # Create the app-specific log directory
    directory indexed_log_dir do
      action                 :create
    end

    Chef::Log.info "Creating runit service for Kafka-contrib project #{app_name_with_index} (#{app_type})"
    runit_service "kafka_#{app_name_with_index}" do
      run_state              app_run_state
      run_restart            false
      template_name          'kafka_contrib_app'
      log_template_name      'kafka_contrib_app'

      options({
        run_as_user:         run_as_user,
        app_type:            app_type,
        app_name:            app_name,
        app_name_with_index: app_name_with_index,
        kafka_home:          kafka_home,
        hadoop_home:         hadoop_home,
        topic:               topic,
        app_options:         app_options,
      })
    end
  end
  
  announce(:kafka_contrib, app_name.to_s.to_sym)
end
