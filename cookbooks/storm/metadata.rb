maintainer       'Travis Dempsey'
maintainer_email 'coders@infochimps.com'
license          'All rights reserved'
description      'Installs/Configures Storm'
long_description IO.read(File.expand_path('../README.mdown', __FILE__))
version          IO.read(File.expand_path('../VERSION', __FILE__))

depends 'silverware'
depends 'runit'
depends 'java'
depends 'install_from'
depends 'zookeeper'

recipe 'storm::default', 'Base configuration for Storm'
recipe 'storm::master',  'Storm master server (nimbus)'
recipe 'storm::worker',  'Storm worker client (supervisor)'
recipe 'storm::ui',      'Storm UI for viewing topologies'

%w[ debian ubuntu centos ].each do |os|
  supports os
end
