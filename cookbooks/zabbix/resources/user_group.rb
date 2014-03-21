actions :create, :destroy

attribute :server,             :kind_of  => String, :default => 'localhost'

attribute :users,      :kind_of  => Array, :default => []
attribute :debug_mode, :equal_to => [true, false]
attribute :banned,     :equal_to => [true, false]
attribute :gui_access, :equal_to => %w[default internal disabled]

def initialize *args
  super
  @action = :create
end
