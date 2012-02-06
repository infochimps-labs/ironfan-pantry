actions :create, :destroy

# These identify the properites of the new host to register
attribute :virtual,     :equal_to => [true, false], :default => false
attribute :templates,   :kind_of  => Array,  :default => []
attribute :host_groups, :kind_of  => Array,  :default => []
attribute :user_macros, :kind_of  => Hash,   :default => {}
attribute :server,      :kind_of  => String, :default => 'localhost'
attribute :monitored,   :equal_to => [true, false]

# Opscode::Aws::Ec2 module in aws cookbook expects this *resource* to
# have these attributes if the corresponding *provider* is planning on
# querying Ec2 resources.
#
# We leave them here but they need not be set when used in a recipe --
# the provider will set them directly.
attribute :aws_access_key,        :kind_of => String
attribute :aws_secret_access_key, :kind_of => String

def initialize *args
  super
  @action = :create
end
