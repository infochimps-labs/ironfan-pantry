define(:hadoop_service, :service_name => nil, :old_service_name => nil, :package_name => nil, :logs => nil, :ports => nil, :daemons => nil) do
  name             = params[:name].to_s
  old_service_name = "#{node[:hadoop][:handle]}-#{params[:old_service_name] || name}"
  service_name     = params[:service_name]     || name
  package_name     = params[:package_name]     || name
  jar_name         = params[:jar_name]         || name

  hadoop_package package_name

  # Set up service
  runit_service "hadoop_#{name}" do
    run_state     node[:hadoop][name][:run_state]
    options       Mash.new().
      merge(node[:hadoop]).
      merge(node[:hadoop][name]).
      merge(:service_name => service_name, :component_name => name, :jar_name => jar_name)
  end
  kill_old_service(old_service_name) do
    only_if{ File.exists?("/etc/init.d/#{old_service_name}") }
  end

  if node[:hadoop][service_name.to_sym]
    ports = {}.tap do |h|
      if node[:hadoop][service_name.to_sym][:port]
        h[:main] = {
          :port     => node[:hadoop][service_name.to_sym][:port],
          :protocol => 'http'
        }
      end
      if node[:hadoop][service_name.to_sym][:dash_port]
        h[:dash] = {
          :port      => node[:hadoop][service_name.to_sym][:dash_port],
          :protocol  => 'http',
          :dashboard => true
        }
      end
      if node[:hadoop][service_name.to_sym][:jmx_dash_port]
        h[:jmx_dash] = {
          :port      => node[:hadoop][service_name.to_sym][:jmx_dash_port],
          :dashboard => true
        }
      end
      h.merge!(params[:ports] || {})
    end

    daemons = {}.tap do |h|
      # This isn't really the *same* thing as having a user but it's
      # lightweight enough until something better (more introspective)
      # comes along.
      if node[:hadoop][service_name.to_sym][:user]
        h[:main] = {
          :name => 'java',
          :user => node[:hadoop][service_name.to_sym][:user],
          :cmd  => "proc_#{service_name}"
        }
      end
      h.merge!(params[:daemons] || {})
    end
  else
    ports, daemons = {}, {}
  end

  logs = {}.tap do |h|
    h[:main] = {
      :path      => File.join(node[:hadoop][:log_dir], "#{node[:cluster_name]}-hadoop-#{service_name}-#{node.name}.log"),
      :logrotate => false
    }
    h.merge!(params[:logs] || {})
  end

  announce(:hadoop, name, :logs => logs, :ports => ports, :daemons => daemons)

end
