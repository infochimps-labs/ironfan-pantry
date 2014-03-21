class Chef
  
  module RubixConnection

    class LogProxy
      attr_accessor :context
      def initialize context
        self.context = context
      end
      def log log_level_code, log_message
        log_level_name = ([:debug, :info, :warn, :error, :fatal][log_level_code] || :info)
        context.log(log_message) do
          level   log_level_name
          message log_message
          action  :nothing
        end.run_action(:write)
      end
    end

    # The version of Rubix we expect to use.
    RUBIX_VERSION = '0.5.14'

    # For a pool of shared connections to Zabbix API servers.
    CONNECTIONS = {  } unless defined?(CONNECTIONS)
    
    def connect_to_zabbix_server ip
      # Use an already existing connection if we have one.
      if ::Chef::RubixConnection::CONNECTIONS[ip]
        Rubix.connection = ::Chef::RubixConnection::CONNECTIONS[ip]
        @connected_to_zabbix = true
        return true
      end

      # Make sure Rubix is available to us.
      retries = 0
      begin
        gem     'rubix', ">= #{::Chef::RubixConnection::RUBIX_VERSION}"
        require 'rubix'
        # Hook up Rubix's logger to Chef's logger.
        ::Rubix.logger = LogProxy.new(self)
      rescue Gem::LoadError, LoadError => e
        gem_package('configliere') { action :nothing }.run_action(:install)
        gem_package('rubix') { action :nothing ; version ::Chef::RubixConnection::RUBIX_VERSION }.run_action(:install)
        Gem.clear_paths
        gem     'rubix', ">= #{::Chef::RubixConnection::RUBIX_VERSION}"
        require 'rubix'
        retries += 1
        retry unless retries > 1
      end

      url = File.join(ip, node.zabbix.api.path)
      begin
        timeout(5) do
          connection = ::Rubix::Connection.new(url, node[:zabbix][:api][:username], node[:zabbix][:api][:password])
          connection.authorize!
          ::Chef::RubixConnection::CONNECTIONS[ip] = connection
          Rubix.connection = ::Chef::RubixConnection::CONNECTIONS[ip] = connection
          @connected_to_zabbix                     = true
        end
      rescue ArgumentError, ::Rubix::Error, ::Errno::ECONNREFUSED, Timeout::Error, Errno::ETIMEDOUT => e
        ::Chef::Log.warn("Could not connect to Zabbix API at #{url} as #{node.zabbix.api.username}: #{e.message}")
        false
      end
    end

    def connected_to_zabbix?
      @connected_to_zabbix
    end
  end

  class Recipe
    
    include ::Chef::RubixConnection
    
    def all_zabbix_server_ips
      realm                 = (node[:discovers][:zabbix][:server]                       rescue nil)
      servers_as_attributes = (node.zabbix.agent.servers                                rescue [])
      discovered_servers    = (discover_all(:zabbix, :server, realm).map(&:private_ip)  rescue [])
      servers_as_attributes + discovered_servers
    end

    def default_zabbix_server_ip
      all_zabbix_server_ips.first
    end

  end
end
