maintainer       "Dhruv Bansal - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      "The most helpful motd file evar"


recipe           "motd::default",                      "Base configuration for motd"
recipe           "motd::ec2",                          "Ec2"

%w[ debian ubuntu ].each do |os|
  supports os
end
