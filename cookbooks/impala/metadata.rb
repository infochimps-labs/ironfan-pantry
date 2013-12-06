maintainer       "Philip (flip) Kromer - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      "Installs/Configures impala"

depends          "java"
depends          "hive"

recipe           "impala::default",                      "Base user/directory configuration for impala"
recipe           "impala::add_cloudera_repo",            "Add package repository for impala"
recipe           "impala::config",                       "Add configuration files for impala"
recipe           "impala::server",                       "Install impala server"
recipe           "impala::shell",                        "Install impala shell"
recipe           "impala::state_store",                  "Install impala state store"


%w[ debian ubuntu ].each do |os|
  supports os
end
