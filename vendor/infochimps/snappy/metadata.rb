maintainer       "Philip (flip) Kromer - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "3.0.0"

description      "Installs/Configures snappy, the compression codec from google"

depends          "install_from"

recipe           "snappy::default",                     "Base configuration for snappy"

%w[ debian ubuntu ].each do |os|
  supports os
end

attribute "snappy/home_dir",
  :display_name          => "Installed location of snappy",
  :description           => "Installed location of snappy",
  :default               => "/usr/local/share/snappy"

attribute "snappy/release_url",
  :display_name          => "Snappy release tarball to install",
  :description           => "Snappy release tarball to install",
  :default               => "http://snappy.googlecode.com/files/snappy-:version:.tar.gz"

attribute "snappy/version",
  :display_name          => "",
  :description           => "",
  :default               => "1.0.4"
