connect_to_zabbix_api!
everything = find_all_nodes_clusters_and_facets

everything[:cluster_names].each do |cluster_name|
  zabbix_host cluster_name do
    virtual      true
    templates    ['Template_Infochimps_Cluster']
    host_groups  ['Clusters']
    user_macros  'CLUSTER_NAME' => cluster_name
  end
end

everything[:cluster_facet_names].each do |cluster_facet_name|
  zabbix_host cluster_facet_name do
    virtual      true
    templates    ['Template_Infochimps_Cluster']
    host_groups  ['Cluster Facets']
    user_macros  'CLUSTER_NAME' => cluster_facet_name
  end
end

everything[:nodes].each do |host_node|

  existing_templates   = host_node[:zabbix][:agent][:templates]   rescue []
  existing_host_groups = host_node[:zabbix][:agent][:host_groups] rescue []

  existing_host_groups << host_node[:cluster_name]
  existing_host_groups << "#{host_node[:cluster_name]}-#{host_node[:facet_name]}" unless host_node[:facet_name].to_s.strip.empty?
  
  zabbix_host host_node[:node_name] do
    templates   [existing_templates, 'Template_Infochimps_Base']
    host_groups existing_host_groups
  end
end
