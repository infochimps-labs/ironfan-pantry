actions :create, :destroy

# These identify the properites of the new host to register
attribute :virtual,     :equal_to => [true, false], :default => false
attribute :templates,   :kind_of => Array, :default => []
attribute :host_groups, :kind_of => Array, :default => []
attribute :user_macros, :kind_of => Hash,  :default => {}

def initialize *args
  super
  @action = :create
end
