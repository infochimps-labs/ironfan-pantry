class Chef
  class Recipe

    def all_zabbix_server_ips
      realm                 = (node[:discovers][:zabbix][:server]                       rescue nil)
      servers_as_attributes = (node.zabbix.agent.servers                                rescue [])
      discovered_servers    = (discover_all(:zabbix, :server, realm).map(&:private_ip)  rescue [])
      servers_as_attributes + discovered_servers
    end

    def default_zabbix_server_ip
      all_zabbix_server_ips.first
    end
    
    def all_nodes_clusters_and_facets
      # Do we want to do 'all nodes that are zabbix agents' or plain
      # just 'all nodes'?
      realm       = discovery_realm('zabbix', 'agent')
      agent_nodes = discover_all_nodes("#{realm}-zabbix-agent")

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
  end
end

