actions :upload

# The IP of the Zabbix web application server.
attribute :server, :kind_of => String, :default => 'localhost'

# The name of the cookbook to look in for the file
attribute :cookbook, :kind_of => String

# These define how properties in the XML file will be processed by the
# web application into resources in the database.
attribute :update_hosts,     :equal_to => [true, false], :default => true
attribute :add_hosts,        :equal_to => [true, false], :default => true
attribute :update_items,     :equal_to => [true, false], :default => true
attribute :add_items,        :equal_to => [true, false], :default => true
attribute :update_triggers,  :equal_to => [true, false], :default => true
attribute :add_triggers,     :equal_to => [true, false], :default => true
attribute :update_graphs,    :equal_to => [true, false], :default => true
attribute :add_graphs,       :equal_to => [true, false], :default => true
attribute :update_templates, :equal_to => [true, false], :default => true

def initialize *args
  super
  @action = :nothing
  @source ||= ::File.basename(name)
end
