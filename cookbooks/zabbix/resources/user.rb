actions :create, :destroy

attribute :server,             :kind_of  => String, :default => 'localhost'

attribute :first_name,         :kind_of  => String
attribute :last_name,          :kind_of  => String
attribute :url,                :kind_of  => String
attribute :auto_login,         :equal_to => [true, false]
attribute :type,               :equal_to => ["normal", "admin", "super_admin"]
attribute :lang,               :kind_of  => String
attribute :theme,              :kind_of  => String
attribute :auto_logout_period, :kind_of  => Integer
attribute :refresh_period,     :kind_of  => Integer
attribute :rows_per_page,      :kind_of  => Integer
attribute :password,           :kind_of  => String
attribute :media,              :kind_of  => Array, :default => []

def initialize *args
  super
  @action = :create
end
