include Chef::RubixConnection

action :create do
  if connected_to_zabbix? && (new_resource.creates.empty? || new_resource.creates.all? { |template_name| Rubix::Template.find(:name => template_name) })
    import_template
  end
end

action :update do
  import_template
end
                           
# From chef/provider/cookbook_file.rb
def file_cache_location
  @file_cache_location ||= begin
    cookbook = run_context.cookbook_collection[new_resource.cookbook || new_resource.cookbook_name]
    cookbook.preferred_filename_on_disk_location(node, :files, new_resource.source)
  end
end

def import_template
  Chef::Log.info("Attempting to import Zabbix template #{new_resource.name}...")
  ::File.open(file_cache_location) do |f|
    begin 
      Rubix::Template.import(f, {
                               # web application into resources in the database.
                               :update_hosts     => new_resource.update_hosts,
                               :add_hosts        => new_resource.add_hosts,
                               :update_items     => new_resource.update_items,
                               :add_items        => new_resource.add_items,
                               :update_triggers  => new_resource.update_triggers,
                               :add_triggers     => new_resource.add_triggers,
                               :update_graphs    => new_resource.update_graphs,
                               :add_graphs       => new_resource.add_graphs,
                               :update_templates => new_resource.update_templates,
                             })
    rescue Rubix::Error => e
      Chef::Log.warn("could not import template #{new_resource.name}: #{e.messaage}")
    end
  end
end

    
