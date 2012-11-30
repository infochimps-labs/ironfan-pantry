maintainer       "Philip (flip) Kromer - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      "Grabbag of utility cookbooks"


recipe           "cloud_utils::burn_ami_prep",         "Burn Ami Prep"
recipe           "cloud_utils::virtualbox_metadata",   "Virtualbox Metadata"
recipe           "cloud_utils::pickle_node",           "Write the node metadata out into a file for later use"

%w[ debian ubuntu ].each do |os|
  supports os
end
