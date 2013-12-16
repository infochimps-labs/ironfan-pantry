maintainer       "Philip (flip) Kromer - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      "Pig: a data analysis program for hadoop. It's like SQL but with less suck and more scalable."

depends          "java"
depends          "install_from"
depends          "hadoop"
depends          "ant"

recipe           "pig::default",                       "Base configuration for pig"
recipe           "pig::install_from_package",          "Installs pig from the cloudera package -- verified compatible, but on a slow update schedule."
recipe           "pig::install_from_release",          "Install From the release tarball."
recipe           "pig::integration",                   "Link in jars from hbase and zookeeper"
recipe           "pig::piggybank",                     "Compiles the Piggybank, a library of useful functions for pig"

%w[ debian ubuntu ].each do |os|
  supports os
end

attribute "pig/home_dir",
  :display_name          => "Location of pig code",
  :description           => "Location of pig code",
  :default               => "/usr/lib/pig"

attribute "pig/release_url",
  :display_name          => "URL of pig release tarball",
  :description           => "You can use template dingbats like `:apache_mirror:`, `:version:`, etc -- see the install_from cookbook for details.",
  :default               => ":apache_mirror:/pig/pig-:version:/pig-:version:.tar.gz"

attribute "pig/combine_splits",
  :display_name          => "tunable: combine small files to reduce the number of map tasks",
  :description           => "Processing input (either user input or intermediate input) from multiple small files can be inefficient because a separate map has to be created for each file. Pig can now combined small files so that they are processed as a single map. combine_splits turns this on or off.",
  :default               => "true"

attribute "pig/version",
  :display_name          => "",
  :description           => "",
  :default               => "0.9.2"

attribute "java/java_home",
  :display_name          => "JAVA_HOME environment variable to set for compilation",
  :description           => "JAVA_HOME environment variable to set for compilation. This should be the path to the 'jre' subdirectory of your Sun Java install (*not* OpenJDK).",
  :default               => "/usr/lib/jvm/java-6-sun/jre"
