#
# Cookbook Name::       zabbix
# Description::         Create Hosts
# Recipe::              create_hosts
# Author::              Dhruv Bansal
#
# Copyright 2011, Dhruv Bansal
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

zabbix_server_ip  = default_zabbix_server_ip
everything_chef   = all_chef_nodes_clusters_and_facets
everything_zabbix = all_zabbix_nodes_clusters_and_facets(zabbix_server_ip)

# Create a Zabbix host for each cluster in Chef.
everything_chef[:cluster_names].each do |cluster_name|
  zabbix_host cluster_name do
    server       zabbix_server_ip
    virtual      true
    templates    ['Template_Cluster']
    host_groups  ['Clusters']
    user_macros  'CLUSTER_NAME' => cluster_name
    monitored    true
  end
end

# Create a Zabbix host for each cluster-facet in Chef.
everything_chef[:cluster_facet_names].each do |cluster_facet_name|
  zabbix_host cluster_facet_name do
    server       zabbix_server_ip
    virtual      true
    templates    ['Template_Cluster']
    host_groups  ['Cluster Facets']
    user_macros  'CLUSTER_NAME' => cluster_facet_name
    monitored    true
  end
end

# Create a Zabbix host for each node (cluster-facet-index) in Chef.
everything_chef[:nodes].each do |host_node|

  existing_templates   = ((host_node.zabbix.templates   || []).to_set rescue [])
  existing_host_groups = ((host_node.zabbix.host_groups || []).to_set rescue [])

  existing_host_groups << 'All Nodes'
  existing_host_groups << host_node.cluster_name
  existing_host_groups << [host_node.cluster_name, host_node.facet_name].join('-')

  existing_templates   << 'Template_Node'

  zabbix_host host_node[:node_name] do
    server      zabbix_server_ip
    templates   existing_templates.to_a
    host_groups existing_host_groups.to_a
    monitored   true
  end
end

# Unmonitor all Zabbix clusters that aren't also Chef clusters.
everything_zabbix[:cluster_names].subtract(everything_chef[:cluster_names]).each do |inaccessible_cluster_name|
  zabbix_host inaccessible_cluster_name do
    server    zabbix_server_ip
    virtual   true
    templates    ['Template_Cluster']
    host_groups  ['Clusters']
    user_macros  'CLUSTER_NAME' => inaccessible_cluster_name
    monitored false
  end
end

# Unmonitor all Zabbix cluster-facets that aren't also Chef cluster-facets.
everything_zabbix[:cluster_facet_names].subtract(everything_chef[:cluster_facet_names]).each do |inaccessible_cluster_facet_name|
  zabbix_host inaccessible_cluster_facet_name do
    server    zabbix_server_ip
    virtual   true
    templates    ['Template_Cluster']
    host_groups  ['Cluster Facets']
    user_macros  'CLUSTER_NAME' => inaccessible_cluster_facet_name
    monitored false
  end
end

# Unmonitor all Zabbix hosts that aren't also Chef nodes.
everything_zabbix[:host_names].subtract(everything_chef[:node_names]).each do |inaccessible_host_name|
  zabbix_host inaccessible_host_name do
    server      zabbix_server_ip
    host_groups ['All Nodes']
    monitored   false
  end
end

