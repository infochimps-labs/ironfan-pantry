require File.expand_path('rubix_connection.rb', File.dirname(__FILE__))

class Chef
  class Recipe
    include Chef::RubixConnection

    def all_zabbix_nodes_clusters_and_facets ip
      everything = { :nodes => Set.new, :node_names => Set.new, :cluster_names => Set.new, :cluster_facet_names => Set.new }
      return everything unless connect_to_zabbix_server(ip)
      
      everything[:hosts]      = Rubix::Host.all
      everything[:host_names] = Set.new(everything[:hosts].map { |host| host.name })
      everything[:host_names].each do |name|
        parts = name.split('-')
        everything[:cluster_names]       << parts[0]              unless parts.empty?
        everything[:cluster_facet_names] << parts[0..1].join('-') unless parts.size == 1
      end
      everything
    end

    def all_zabbix_server_ips
      realm                 = (node[:discovers][:zabbix][:server]                       rescue nil)
      servers_as_attributes = (node.zabbix.agent.servers                                rescue [])
      discovered_servers    = (discover_all(:zabbix, :server, realm).map(&:private_ip)  rescue [])
      servers_as_attributes + discovered_servers
    end

    def default_zabbix_server_ip
      all_zabbix_server_ips.first
    end
    
    def all_chef_nodes_clusters_and_facets
      everything              = { :nodes => Set.new, :node_names => Set.new, :cluster_names => Set.new, :cluster_facet_names => Set.new }
      realm                   = discovery_realm('zabbix', 'agent')
      everything[:nodes]      = discover_all_nodes("#{realm}-zabbix-agent")
      
      # from aws cookbook, libraries/ec2.rb
      availability_zone = open('http://169.254.169.254/latest/meta-data/placement/availability-zone/'){|f| f.gets}
      raise "Cannot find availability zone!" unless availability_zone
      Chef::Log.debug("Instance's availability zone is #{availability_zone}")
      r = availability_zone
      region = r[0, r.length-1]
      ec2 = RightAws::Ec2.new(node.aws.aws_access_key, node.aws.aws_secret_access_key, { :logger => Chef::Log, :region => region })
      
      everything[:nodes].each do |agent_node|
        inaccessible = false
        begin
          response     = ec2.describe_instances(agent_node[:ec2][:instance_id])
          state        = response.first[:aws_state] if response.size == 1
          inaccessible = true                       if %w[stopping stopped terminating terminated].include?(state)
        rescue RightAws::AwsError => e
          Chef::Log.warn("Could not determine monitoring state for #{host_node.node_name}: #{e.message}")
        end
        unless inaccessible
          everything[:cluster_names]       << agent_node[:cluster_name]
          everything[:cluster_facet_names] << [agent_node[:cluster_name], agent_node[:facet_name]].join('-')
          everything[:node_names]          << agent_node[:node_name]
        end
      end
      everything
    end
    
  end
end

