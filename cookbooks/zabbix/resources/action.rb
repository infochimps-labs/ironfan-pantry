actions :create, :destroy

attribute :server,             :kind_of  => String, :default => 'localhost'

attribute :event_source,             :equal_to => [:triggers, :discovery, :auto_registration]
attribute :escalation_time,          :kind_of  => Integer, default: 60
attribute :enabled,                  :equal_to => [true, false], :default => true
attribute :message_subject,          :kind_of  => String
attribute :message_body,             :kind_of  => String
attribute :send_recovery_message,    :equal_to => [true, false]
attribute :recovery_message_subject, :kind_of  => String
attribute :recovery_message_body,    :kind_of  => String
attribute :conditions,               :kind_of  => Array, :default => []
attribute :condition_operator,       :equal_to => [:and_or, :and, :or]
attribute :operations,               :kind_of  => Array, :default => []

def initialize *args
  super
  @action = :create
end
