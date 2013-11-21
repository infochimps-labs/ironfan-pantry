maintainer       "Nathaniel Eliot - Infochimps, Inc"
maintainer_email "temujin9@infochimps.com"
license          "All rights reserved"
description      "Rundeck is an open-source process automation and command orchestration tool with a web console."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

depends "runit"
depends "silverware"
depends "nginx"

recipe "rundeck::default", "Sets up the Rundeck user and basic installation directories"

recipe "rundeck::server",                        "Installs a Rundeck server, complete with Chef-Rundeck integration"
recipe "rundeck::install_server_from_deb",       "Installs a Rundeck server from a downloaded .deb package file"
recipe "rundeck::install_chef-rundeck",          "Installs the Chef-Rundeck gem which provides a small web-server tool to relay data from a Chef server to Rundeck"
recipe "rundeck::integration_with_chef-rundeck", "Create a default project pointing at a resource URL provided by Chef Rundeck"
recipe "rundeck::ssl",                           "Configure the Rundeck server's SSL behavior"
recipe "rundeck::sshdir",                        "Create rundeck user's SSH directory"
recipe "rundeck::sshkey",                        "Create an SSH key for the Rundeck server"

recipe "rundeck::client", "Allows a Rundeck server to SSH into this node"

%w[ debian ubuntu ].each do |os|
  supports os
end
