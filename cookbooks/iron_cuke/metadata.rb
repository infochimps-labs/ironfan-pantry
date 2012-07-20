maintainer       "Dieterich Lawson"
maintainer_email "dieterich@infochimps.com"
license          "Apache 2.0"
description      "Installs/Configures iron_cuke"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe           "iron_cuke::default",                  "Base configuration for iron_cuke"

#%w[ debian ubuntu ].each do |os|
#    supports os
#end

attribute "iron_cuke/home_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/etc/iron_cuke"

attribute "iron_cuke/user",
  :display_name          => "",
  :description           => "",
  :default               => "root"
