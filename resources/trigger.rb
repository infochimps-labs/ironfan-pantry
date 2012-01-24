actions :create, :destroy

attribute :expression, :kind_of => String, :default => ''
attribute :host,       :kind_of => String
attribute :enabled,    :equal_to => [true, false], :default => true
attribute :priority,   :equal_to => [:information, :warning, :average, :high, :disaster], :default => :average
attribute :comments,   :kind_of => String, :default => ''
attribute :server,     :kind_of => String, :default => 'localhost'

def initialize *args
  super
  @action = :create
end
