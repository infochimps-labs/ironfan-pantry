actions :create, :destroy

attribute :aws_access_key,        :kind_of  => String
attribute :aws_secret_access_key, :kind_of  => String
attribute :permissions,           :kind_of  => String,        :default => nil
attribute :headers,               :kind_of  => Hash,          :default => {}
attribute :force,                 :equal_to => [true, false], :default => false
