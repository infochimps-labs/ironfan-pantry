require File.expand_path('silverware.rb', File.dirname(__FILE__))

module Ironfan

  #
  # Ironfan::Discovery --
  #
  # Allow nodes to discover the location for a given component at runtime, adapting
  # when new components announce.
  #
  # Operations:
  #
  # * announce a component. A timestamp records the last announcement.
  # * discover all servers announcing the given component.
  # * discover the most recent server for that component.
  #
  #
  module Discovery
    include NodeUtils

    #
    # Announce that you provide the given component in some realm (by default,
    # this node's cluster).
    #
    # @param [Symbol] sys    name of the system
    # @param [Symbol] subsys name of the subsystem
    # @param [Hash] opts extra attributes to pass to the component object
    # @option opts [String] :realm Offer the component within this realm -- by
    #   default, the current node's cluster
    #
    def announce(sys, subsys, opts={}, &block)
      opts           = Mash.new(opts)
      opts[:realm] ||= node[sys][subsys][:announce_as] rescue nil
      opts[:realm] ||= node[sys][:announce_as] rescue nil
      opts[:realm] ||= node[:cluster_name] rescue nil
      component = Component.new(node, sys, subsys, opts)
      Chef::Log.info("Announcing component #{component.fullname}")
      #
      component.instance_eval(&block) if block
      #
      node.set[:announces][component.fullname] = component.to_hash
      node_changed!
      component
    end

    # Find all announcements for the given system
    #
    # @example
    #   discover_all(:cassandra, :seeds)           # all cassandra seeds for current cluster
    #   discover_all(:cassandra, :seeds, 'bukkit') # all cassandra seeds for 'bukkit' cluster
    #
    # @return [Ironfan::Component] component from server to most recently-announce
    def discover_all(sys, subsys, realm=nil)
      realm ||= discovery_realm(sys,subsys)
      component_name = Ironfan::Component.fullname(realm, sys, subsys)
      Chef::Log.debug("discovering #{component_name} for #{sys}-#{subsys} in #{realm} (#{Mash.new(node[:discovers].to_hash)})")
      #
      servers = discover_all_nodes(component_name)
      servers.map do |server|
        hsh = server[:announces][component_name]
        hsh[:realm] = realm
        Ironfan::Component.new(server, sys, subsys, hsh)
      end
    end

    # Find the latest announcement for the given system
    #
    # @example
    #   discover(:redis, :server)             # redis server for current cluster
    #   discover(:redis, :server, 'uploader') # redis server for 'uploader' realm
    #
    # @return [Ironfan::Component] component from server to most recently-announce
    def discover(sys, subsys, realm=nil)
      discover_all(sys, subsys, realm).last
    end


    # Like #discover (find the latest announcement for the given system), but
    # raises an error if not found
    def discover!(*args)
      discover(*args) or raise("Cannot find #{realm}-#{sys}-#{subsys}")
    end

    def discovery_realm(sys, subsys=nil)
      realm   = (node[:discovers][sys][subsys] rescue nil) unless subsys.nil?
      realm ||= (node[:discovers][sys] rescue nil) if (node[:discovers][sys].kind_of? String rescue false)
      realm ||= node[:cluster_name]
    end

    def node_components(server)
      server[:announces].map do |name, hsh|
        realm, sys, subsys = name.split("-", 3)
        hsh[:realm] = realm
        Ironfan::Component.new(server, sys, subsys, hsh)
      end
    end

    # Discover all components with the given aspect -- eg logs, or ports, or
    # dashboards -- on the current node
    #
    # @param [Symbol] aspect in handle form
    #
    # @example
    #   components_with(:log)
    #
    # Can also be passed a specific node
    #
    # @example
    #   components_with(:ports, <CHEF NODE INSTANCE>)
    #
    def components_with(aspect, server=nil)
      node_components(server || self.node).select{|comp| not comp.send(aspect).empty? }
    end

  protected
    #
    # all nodes that have announced the given component, in ascending order of
    # timestamp (most recent is last)
    #
    def discover_all_nodes(component_name)
      all_servers = search(:node, "announces:#{component_name}" ) rescue []
      all_servers.reject!{|server| %w[stop].include?(server.node[:state]) }  # remove nodes which are stopped...
      all_servers.reject!{|server| server.name == node.name}  # remove this node...
      all_servers << node if node[:announces][component_name] # & use a fresh version
      Chef::Log.warn("No node announced for '#{component_name}'") if all_servers.empty?
      all_servers.sort_by{|server| server[:announces][component_name][:timestamp] }
    end

  end
end

class Chef::ResourceDefinition ; include Ironfan::Discovery ; end
class Chef::Resource           ; include Ironfan::Discovery ; end
class Chef::Recipe             ; include Ironfan::Discovery ; end
