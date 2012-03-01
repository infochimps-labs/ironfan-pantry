class Chef

  class Recipe

    def node_zabbix_host_groups(the_node=nil)
      the_node ||= node
      Set.new.tap do |hgs|
        hgs << the_node[:cluster_name] if the_node[:cluster_name]
        hgs << "#{the_node[:cluster_name]}-#{the_node[:facet_name]}" if the_node[:cluster_name] && the_node[:facet_name]
        if the_node[:zabbix] && the_node[:zabbix][:host_groups]
          the_node[:zabbix][:host_groups].each_pair do |service, groups|
            groups.each { |g| hgs << g }
          end
        end
      end.to_a
    end

    def node_zabbix_templates(the_node=nil)
      the_node ||= node
      Set.new.tap do |ts|
        if the_node[:zabbix] && the_node[:zabbix][:templates]
          the_node[:zabbix][:templates].each_pair do |service, templates|
            templates.each { |t| ts << t }
          end
        end
      end.to_a
    end
    
  end
end
