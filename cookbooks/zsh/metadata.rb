maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs zsh"
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

recipe "zsh", "Installs zsh"

%w{ubuntu debian}.each do |os|
  supports os
end
