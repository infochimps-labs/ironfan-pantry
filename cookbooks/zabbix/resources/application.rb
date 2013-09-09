actions :create, :destroy

attribute :host,   :kind_of => String
attribute :server, :kind_of => String, :default => 'localhost'

def initialize *args
  super
  @action = :create
end
