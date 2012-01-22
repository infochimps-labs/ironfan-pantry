class Chef
  class Recipe

    def connect_to_zabbix_api!
      begin
        require 'rubix'
      rescue LoadError => e
        gem_package('rubix')
        Gem.clear_paths
        require 'rubix'
      end
      Rubix.logger = Chef::Log.logger
      Rubix.connect(File.join(node[:zabbix][:agent][:servers][0], 'api_jsonrpc.php'), node[:zabbix][:api][:username], node[:zabbix][:api][:password])
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
  end
end
