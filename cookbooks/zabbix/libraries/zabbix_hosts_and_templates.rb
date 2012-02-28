class Chef

  class Recipe

    def node_zabbix_host_groups(the_node=nil)
      the_node ||= node
      Set.new.tap do |hgs|
        hgs << node[:cluster_name] if node[:cluster_name]
        hgs << "#{node[:cluster_name]}-#{node[:facet_name]}" if node[:cluster_name] && node[:facet_name]
        return hgs.to_a unless node[:zabbix][:host_groups]
        node[:zabbix][:host_groups].each_pair do |service, groups|
          groups.each { |g| hgs << g }
        end
      end.to_a
    end

    def node_zabbix_templates(the_node=nil)
      the_node ||= node
      Set.new.tap do |ts|
        return ts.to_a unless node[:zabbix] && node[:zabbix][:templates]
        node[:zabbix][:templates].each_pair do |service, templates|
          templates.each { |t| ts << t }
        end
      end.to_a
    end
    
  end
end
