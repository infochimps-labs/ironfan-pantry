maintainer       "Logan Lowell - Infochimps, Inc"
maintainer_email "logan@infochimps.com"
license          "All rights reserved"
description      "Installs/Configures Storm"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.mdown'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

depends "silverware"
depends "runit"
depends "java"
depends "install_from"
depends "zookeeper"
depends "zeromq"

recipe "storm::default", "Base configuration for Storm"
recipe "storm::master",  "Storm master server (nimbus)"
recipe "storm::worker",  "Storm worker client (supervisor)"
recipe "storm::ui",      "Storm UI for viewing topologies"

%w[ debian ubuntu ].each do |os|
  supports os
end

attribute "storm/home_dir",
  :display_name => "",
  :description  => "",
  :default =>      "/usr/local/storm"