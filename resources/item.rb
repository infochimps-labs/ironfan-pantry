actions :create, :destroy

attribute :type,         :kind_of => Symbol
attribute :value_type,   :kind_of => Symbol
attribute :key,          :kind_of => String
attribute :applications, :kind_of => Array, :default => []
attribute :host,         :kind_of => String
attribute :units,        :kind_of => String
attribute :server,       :kind_of => String, :default => 'localhost'

def initialize *args
  super
  @action = :create
end
