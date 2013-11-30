name             'package-server'
maintainer       'infochimps'
maintainer_email 'coders@infochimps.com'
license          'Apache 2.0'
description      'Installs/Configures package-server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

depends 'nginx'
depends 'route53'
depends 'runit'


