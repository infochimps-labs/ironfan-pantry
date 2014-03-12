maintainer       "Philip (flip) Kromer - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      "Install and configure Hue"

depends "hive"
depends "impala"
depends "hadoop"
depends 'cloud_utils'

%w[ debian ubuntu ].each do |os|
  supports os
end
