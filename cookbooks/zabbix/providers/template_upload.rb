include Chef::RubixConnection

action :upload do
  upload_template
end

def load_current_resource
  return unless connect_to_zabbix_server(new_resource.server)
end
                           
# From chef/provider/cookbook_file.rb
def file_cache_location
  @file_cache_location ||= begin
    cookbook = run_context.cookbook_collection[new_resource.cookbook || new_resource.cookbook_name]
    cookbook.preferred_filename_on_disk_location(node, :files, new_resource.name)
  end
end

def upload_template
  Chef::Log.info("Attempting to upload Zabbix template #{new_resource.name}...")
  ::File.open(file_cache_location) do |f|
    begin 
      Rubix::Template.import(f, {
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
      Chef::Log.warn("could not upload template #{new_resource.name}: #{e.message}")
    end
  end
end
