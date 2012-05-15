maintainer       "Infochimps"
maintainer_email "josh@infochimps.com"
license          "All rights reserved"
description      "Installs/Configures hadoop_lzo"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "3.1.1"

depends          "java"
depends          "install_from"
depends          "hadoop_cluster"
depends          "ant"

recipe           "hadoop_lzo::default",                       "Base configuration for hadoop_lzo"

%w[ debian ubuntu ].each do |os|
  supports os
end

attribute "hadoop_lzo/home_dir",
  :display_name          => "Location of hadoop lzo code",
  :description           => "Location of hadoop lzo code",
  :default               => "/usr/lib/hadoop_lzo"

attribute "hadoop_lzo/release_url",
  :display_name          => "URL of hadoop_lzo release tarball",
  :description           => "You can use template dingbats like `:apache_mirror:`, `:version:`, etc -- see the install_from cookbook for details.",
  :default               => "https://github.com/cloudera/hadoop_lzo/tarball/master"

attribute "hadoop_lzo/version",
  :display_name          => "",
  :description           => "",
  :default               => "0.4.14"

attribute "java/java_home",
  :display_name          => "JAVA_HOME environment variable to set for compilation",
  :description           => "JAVA_HOME environment variable to set for compilation. This should be the path to the 'jre' subdirectory of your Sun Java install (*not* OpenJDK).",
  :default               => "/usr/lib/jvm/java-6-sun/jre"
