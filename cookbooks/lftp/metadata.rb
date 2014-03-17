# encoding: UTF-8

maintainer "Benedikt Böhm"
maintainer_email "bb@xnull.de"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      "LFTP is a file transfer program supporting a number of network protocols"

recipe           "lftp::default",                 "Base configuration for zookeeper"

%w[ debian gentoo ].each do |os|
  supports os
end

