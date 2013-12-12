maintainer       "Philip (flip) Kromer - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      "Installs/Configures hive"

depends          "java"
depends          "hadoop"

recipe           "hive::default",                      "Base user and directory configuration for hive"
recipe           "hive::config",                       "Install configuration files for hive"
recipe           "hive::metastore",                    "Install hive metastore"
recipe           "hive::server",                       "Install hive server"
recipe           "hive::mysql_setup",                  "Initialize mysql database and user for hive"

%w[ debian ubuntu ].each do |os|
  supports os
end
