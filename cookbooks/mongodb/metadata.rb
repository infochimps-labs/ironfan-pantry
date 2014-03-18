maintainer       "brandon.bell"
maintainer_email "remuso@gmail.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      "MongoDB is a scalable, high-performance, open source NoSQL database. "

depends          "runit"
depends          "volumes"
depends		       "install_from"
depends          "cloud_utils"

recipe           "mongodb::server",                    "MongoDB server"
recipe           "mongodb::install_from_package",      "Install MongoDB from package"

%w[ debian ubuntu ].each do |os|
  supports os
end

# Package information
attribute "mongodb/version",
  :display_name 	 => "",
  :description 		 => "",
  :default  	       	 => "2.2.1"

attribute "mongodb/i686/release_file_md5",
  :display_name          => "",
  :description           => "",
  :default               => "21153b201cad912c273d754b02eba19b"

attribute "mongodb/i686/release_url",
  :display_name          => "",
  :description           => "",
  :default               => "http://fastdl.mongodb.org/linux/mongodb-linux-i686-2.2.1.tgz"

attribute "mongodb/x86_64/release_file_md5",
  :display_name          => "",
  :description           => "",
  :default               => "6b2cce94194113ebfe2a14bdb84ccd7e"

attribute "mongodb/x86_64/release_url",
  :display_name          => "",
  :description           => "",
  :default               => "http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.2.1.tgz"

# User Information
attribute "mongodb/user",
  :display_name          => "",
  :description           => "",
  :default               => "mongodb"

attribute "users/mongodb/uid",
  :display_name          => "",
  :description           => "",
  :default               => "5001"

attribute "groups/mongodb/gid",
  :display_name          => "",
  :description           => "",
  :default               => "5001"

# Directories
attribute "mongodb/home_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/usr/lib/mongodb"

attribute "mongodb/log_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/var/log/mongodb"

attribute "mongodb/conf_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/etc/mongodb"

attribute "mongodb/pid_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/var/run/mongodb"

attribute "mongodb/data_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/var/lib/mongodb"

attribute "mongodb/journal_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/var/lib/mongodb/journal"

#Configuration
attribute "mongodb/server/mongod_port",
  :display_name          => "",
  :description           => "",
  :default               => "27017"

attribute "mongodb/server/bind_ip",
  :display_name          => "",
  :description           => "",
  :default               => ""

attribute "mongodb/server/rest",
  :display_name          => "",
  :description           => "",
  :default               => "false"
