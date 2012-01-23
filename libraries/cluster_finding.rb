module Chef
  module Zabbix
    
    def connect_to_zabbix_api!
      begin
        require 'rubix'
      rescue LoadError => e
        gem_package('rubix')
        Gem.clear_paths
        require 'rubix'
      end
      Rubix.logger = Chef::Log.logger
      master = all_zabbix_server_ips.first
      Rubix.connect(File.join(master, node.zabbix.api.path), node[:zabbix][:api][:username], node[:zabbix][:api][:password])
    end
    
    def all_zabbix_server_ips
      discover_all(:zabbix, :master).map(&:private_ip) + node.zabbix.agent.servers
    end
    
    def all_nodes_clusters_and_facets
      # Do we want to do 'all nodes that are zabbix agents' or plain
      # just 'all nodes'?
      agent_nodes = discover_all_nodes('*-zabbix-agent')

      all_node_names          = Set.new(agent_nodes.map { |agent_node| agent_node[:node_name] })
      all_cluster_names       = Set.new
      all_cluster_facet_names = Set.new
      
      agent_nodes.each do |agent_node|
        all_cluster_names       << agent_node[:cluster_name]
        all_cluster_facet_names << "#{agent_node[:cluster_name]}-#{agent_node[:facet_name]}" unless agent_node[:facet_name].to_s.strip.empty?
      end
      {
        :nodes               => agent_nodes,
        :node_names          => all_node_names,
        :cluster_names       => all_cluster_names,
        :cluster_facet_names => all_cluster_facet_names
      }
    end

    def zabbix_database_hostname
      case
      when node.zabbix.database.install_method == 'mysql'
        node.zabbix.database.host
      when node.zabbix.database.install_method == 'rds'
        zabbix_rds_instance_hostname
      end
    end

    def zabbix_rds_instance_name
      [discovery_realm(:zabbix, :database), 'zabbix'].join('-')
    end

    def zabbix_rds_instance_hostname
      begin
        rds_instance = rds.describe_db_instances(zabbix_rds_database_instance_name)
      rescue RightAws::AwsError => e
        if e.message =~ /not found/i
          Chef::Log.info("Waiting for RDS instance '#{zabbix_rds_instance_name}' to be assigned a hostname...")
          sleep 5.0
          zabbix_rds_instance_hostname
        else
          raise e
        end
      end
    end
    rds_instance.first[:endpoint_address] rescue nil
  end
  
end
