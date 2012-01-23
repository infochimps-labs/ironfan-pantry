
module ClusterChef
  module CookbookUtils

    #
    # Run state helpers
    #

    def run_state_includes?(hsh, state)
      Array(hsh[:run_state]).map(&:to_s).include?(state.to_s)
    end

    def startable?(hsh)
      run_state_includes?(hsh, :start)
    end

    # among the given components services, the ones this machine actually provides
    def announced_services(component_name, service_names)
      service_names.
        select{|svc| node[:announces]["#{node[:cluster_name]}-#{component_name}-#{svc}"] }
    end

    def notify_startable_services(component_name, service_names)
      announced_services(component_name, service_names).each do |svc|
        if startable?(node[component_name][svc])
          notifies :restart, "service[#{component_name}_#{svc}]", :delayed
        end
      end
    end

    #
    # Assert node state
    #
    def complain_if_not_sun_java(program)
      unless( node['java']['install_flavor'] == 'sun')
        warn "Warning!! You are *strongly* recommended to use Sun Java for #{program}. Set node['java']['install_flavor'] = 'sun' in a role -- right now it's '#{node['java']['install_flavor']}'"
      end
    end

    #
    # Best public or private IP
    #

    #
    # Change all occurences of a given line in-place in a file
    #
    # @param [String] name       - name for the resource invocation
    # @param [String] filename   - the file to modify (in-place)
    # @param [String] old_line   - the string to replace
    # @param [String] new_line   - the string to insert in its place
    # @param [String] shibboleth - a simple foolproof string that should be
    #    present after this works
    #
    def munge_one_line(name, filename, old_line, new_line, shibboleth)
      execute name do
        command %Q{sed -i -e 's|#{old_line}|#{new_line}| ' '#{filename}'}
        not_if  %Q{grep -q -e '#{shibboleth}' '#{filename}'}
        only_if{ File.exists?(filename) }
        yield if block_given?
      end
    end

  end
end

class Chef::ResourceDefinition ; include ClusterChef::CookbookUtils ; end
class Chef::Resource           ; include ClusterChef::CookbookUtils ; end
class Chef::Recipe             ; include ClusterChef::CookbookUtils ; end
class Chef::Provider::NodeMetadata < Chef::Provider ; include ClusterChef::CookbookUtils ; end
