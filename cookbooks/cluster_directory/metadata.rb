maintainer        "Josh Bronson"
maintainer_email  "coders@infochimps.com"
license           "Apache 2.0"
description       "Provides useful Flume sinks, sources, and decorators."
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

supports "ubuntu",   ">= 10.04"
supports "debian",   ">= 6.0"

recipe "cluster_directory::default",       "Does nothing."
recipe "cluster_directory::config_file",   "Writes the directory."
