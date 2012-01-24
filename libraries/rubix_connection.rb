class Chef
  
  module RubixConnection

    # FIXME -- This is a hack to be able to share an expensive to
    # renew connection with the Zabbix API between different
    # providers.  There is definitely a better way to do this.
    CONNECTION = { :established => false, :server => nil }
    
    def zabbix_server= ip
      return if ip == ::Chef::RubixConnection::CONNECTION[:server] && ::Chef::RubixConnection::CONNECTION[:established]
      begin
        require 'rubix'
      rescue LoadError => e
        gem_package('rubix') { action :nothing }.run_action(:install)
        Gem.clear_paths
        require 'rubix'
      end
      ::Rubix.logger = Chef::Log.logger
      url    = File.join(ip, node.zabbix.api.path)
      ::Rubix.connect(url, node[:zabbix][:api][:username], node[:zabbix][:api][:password])
      ::Chef::RubixConnection::CONNECTION[:established] = true
      ::Chef::RubixConnection::CONNECTION[:server]      = ip
    end
  end
end
