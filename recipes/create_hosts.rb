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

zabbix_server_ip = default_zabbix_server_ip
everything       = all_nodes_clusters_and_facets

# Create a host for each cluster.
everything[:cluster_names].each do |cluster_name|
  begin
    zabbix_host cluster_name do
      server       zabbix_server_ip
      virtual      true
      templates    ['Template_Cluster']
      host_groups  ['Clusters']
      user_macros  'CLUSTER_NAME' => cluster_name
    end
  rescue ::Rubix::Error => e
    Chef::Log.warn("Could not create host #{cluster_name}")
  end
end

# Create a host for each cluster-facet.
everything[:cluster_facet_names].each do |cluster_facet_name|
  begin
    zabbix_host cluster_facet_name do
      server       zabbix_server_ip
      virtual      true
      templates    ['Template_Cluster']
      host_groups  ['Cluster Facets']
      user_macros  'CLUSTER_NAME' => cluster_facet_name
    end
  rescue ::Rubix::Error => e
    Chef::Log.warn("Could not create host #{cluster_name}")
  end
  
end

# Create a host for each node (cluster-facet-index).
everything[:nodes].each do |host_node|

  existing_templates   = ((host_node.zabbix.templates   || []).to_set rescue [])
  existing_host_groups = ((host_node.zabbix.host_groups || []).to_set rescue [])

  existing_host_groups << 'All Nodes'
  existing_host_groups << host_node.cluster_name
  existing_host_groups << [host_node.cluster_name, host_node.facet_name].join('-')

  existing_templates   << 'Template_Node'
  begin  
    zabbix_host host_node[:node_name] do
      server      zabbix_server_ip
      templates   existing_templates.to_a
      host_groups existing_host_groups.to_a
    end
  rescue ::Rubix::Error => e
    Chef::Log.warn("Could not create host #{cluster_name}")
  end

end
