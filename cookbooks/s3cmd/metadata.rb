maintainer       "Brandon Bell - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      "s3cmd - Installs s3cmd and configures global configuration"

depends          "aws"
recipe           "s3cmd::default",       "Default Recipe"

%w[ debian ubuntu ].each do |os|
  supports os
end
