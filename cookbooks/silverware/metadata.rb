maintainer       "Philip (flip) Kromer - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "3.1.2"

description      "Cluster orchestration -- coordinates discovery, integration and decoupling of cookbooks"


recipe           "silverware::default",                  "Base configuration for silverware"

%w[ debian ubuntu ].each do |os|
  supports os
end

attribute "silverware/conf_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/etc/silverware"

attribute "silverware/log_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/var/log/silverware"

attribute "silverware/home_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/etc/silverware"

attribute "silverware/user",
  :display_name          => "",
  :description           => "",
  :default               => "root"

attribute "users/root/primary_group",
  :display_name          => "",
  :description           => "",
  :default               => "root"
