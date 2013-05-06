maintainer       "Brandon Bell - Infochimps, Inc."
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
description      "Installs s3fs and mounts s3 bucket locally"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

depends          "aws"

recipe           "default",               "Default recipe"
recipe           "install_from_release",  "Installs s3fs from source"

%w{ debian ubuntu centos redhat }.each do |os|
  supports os
end
