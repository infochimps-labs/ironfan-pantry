class Chef
  
  module RubixConnection

    # For a pool of shared connections to Zabbix API servers.
    CONNECTIONS = {  }
    
    def connect_to_zabbix_server ip
      # Use an already existing connection if we have one.
      if ::Chef::RubixConnection::CONNECTIONS[ip]
        Rubix.connection = ::Chef::RubixConnection::CONNECTIONS[ip]
        @connected_to_zabbix = true
        return true
      end

      # Make sure Rubix is available to us.
      begin
        require 'rubix'
      rescue LoadError => e
        gem_package('rubix') { action :nothing }.run_action(:install)
        Gem.clear_paths
        require 'rubix'
      end

      # Hook up Rubix's logger to Chef's logger.
      ::Rubix.logger = Chef::Log.logger
      
      url = File.join(ip, node.zabbix.api.path)
      begin
        connection = ::Rubix::Connection.new(url, node[:zabbix][:api][:username], node[:zabbix][:api][:password])
        connection.authorize!
        ::Chef::RubixConnection::CONNECTIONS[ip] = connection
        Rubix.connection = ::Chef::RubixConnection::CONNECTIONS[ip] = connection
        @connected_to_zabbix                     = true
      rescue ArgumentError, ::Rubix::Error => e
        ::Chef::Log.warn("Could not connect to Zabbix API at #{url} as #{node.zabbix.api.username}: #{e.message}")
        false
      end
    end

    def connected_to_zabbix?
      @connected_to_zabbix
    end
    
  end
end
