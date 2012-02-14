actions :create, :destroy

attribute :server, :kind_of => String, :default => 'localhost'

# These are the attributes that control the actual media type in
# Zabbix
attribute :type,        :equal_to => [:email, :script, :sms, :jabber, :ez_texting], :default => :script
attribute :smtp_server, :kind_of  => String
attribute :helo,        :kind_of  => String
attribute :email,       :kind_of  => String
attribute :path,        :kind_of  => String
attribute :modem,       :kind_of  => String
attribute :username,    :kind_of  => String
attribute :password,    :kind_of  => String

def initialize *args
  super
  @action = :create
end
