actions :create, :destroy

attribute :server, :kind_of => String, :default => 'localhost'

def initialize *args
  super
  @action = :create
end
