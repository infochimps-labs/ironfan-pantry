maintainer       "Brandon Bell - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      "Sets up a Yum and/or Apt server."

depends          "apache2"

recipe           "repo::apache_config",                 "Installs and configures Apache"
recipe           "repo::apt",                           "Sets reprepo for you Debian based packages."
recipe           "repo::apt_repository",                "Adds sources for the configured 'local' apt repostory"
recipe           "repo::default",                       "Default placeholder recipe"
recipe           "repo::fpm",                           "Intalls fpm to make your package creations easy"
recipe           "repo::keys",                          "Import public keys for upstream repos"
#recipe           "repo::yum",                           "TODO"

%w[ debian ubuntu redhat centos ].each do |os|
  supports os
end
