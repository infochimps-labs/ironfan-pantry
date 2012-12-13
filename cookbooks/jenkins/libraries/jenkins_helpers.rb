#
# Useful methods for jenkins setup:
# * add a jenkins plugin to the plugins list
#
module JenkinsHelpers
  include Ironfan::NodeUtils

  module_function # call JenkinsHelpers.foo, or include and call #foo

  def jenkins_plugins(*plugin_list)
    existing_plugins = node[:jenkins][:server][:plugins].map(&:to_s)
    plugins_to_add   = plugin_list.map(&:to_s) - existing_plugins
    unless plugins_to_add.empty?
      node.set[:jenkins][:server][:plugins] = existing_plugins + plugins_to_add
      node_changed!
    end
  end
end

Chef::Recipe.class_eval do
  include JenkinsHelpers
end
