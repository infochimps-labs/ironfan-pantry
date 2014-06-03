maintainer       'Travis Dempsey'
maintainer_email 'coders@infochimps.com'
license          'Apache 2.0'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      'Installs/Configures Impala'

depends          'java'

recipe           'impala::default',     'Base user/directory configuration for Impala'
recipe           'impala::config',      'Add configuration files for Impala'
recipe           'impala::server',      'Install Impala server'
recipe           'impala::shell',       'Install Impala shell'
recipe           'impala::state_store', 'Install Impala state store'

%w[ debian ubuntu centos ].each do |os|
  supports os
end
