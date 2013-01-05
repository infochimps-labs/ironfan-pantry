maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs emacs"
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

recipe "emacs", "Installs Emacs"

%w{ ubuntu debian redhat centos scientific fedora freebsd }.each do |os|
  supports os
end
