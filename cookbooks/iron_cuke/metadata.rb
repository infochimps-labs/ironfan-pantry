maintainer       "Dieterich Lawson"
maintainer_email "dieterich@infochimps.com"
license          "Apache 2.0"
description      "Installs/Configures iron_cuke"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

depends "silverware"

recipe           "iron_cuke::default",                  "Base configuration for iron_cuke"
recipe           "iron_cuke::judge",                  "Base configuration for iron_cuke"
recipe           "iron_cuke::learn",                  "Fetches announces for iron_cuke"

attribute "iron_cuke/home_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/etc/iron_cuke"

attribute "iron_cuke/conf_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/etc/iron_cuke"

attribute "iron_cuke/conf_dir",
  :display_name          => "",
  :description           => "",
  :default               => "git://github.com/infochimps-labs/iron_cuke.git"

attribute "iron_cuke/user",
  :display_name          => "",
  :description           => "",
  :default               => "root"

attribute "iron_cuke/group",
  :display_name          => "",
  :description           => "",
  :default               => "wheel"


