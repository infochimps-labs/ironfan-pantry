#
# Locations
#

default[:mongodb][:data_dir]                        = nil       # set by volume_dirs
default[:mongodb][:home_dir]                        = "/usr/lib/mongodb"
default[:mongodb][:conf_dir]                        = "/etc/mongodb"
# default[:mongodb][:log_dir]                         = "/var/log/mongodb"
# default[:mongodb][:log_path]                        = ::File.join(default[:mongodb][:log_dir],"mongodb.log")
default[:mongodb][:pid_dir]                         = "/var/run/mongodb"
default[:mongodb][:journal_dir]                     = "/var/lib/mongodb/journal"

#
# User
#
if platform_family?('debian')
  default[:mongodb][:user]                            = 'mongodb'
  default[:mongodb][:group]                           = 'mongodb'
  default[:users]['mongodb'][:uid]                    = 362
  default[:groups]['mongodb'][:gid]                   = 362
elsif platform_family?('rhel')
  default[:mongodb][:user]                             = 'mongod'
  default[:mongodb][:group]                            = 'mongod'
  default[:users]['mongod'][:uid]                     = 362
  default[:groups]['mongod'][:gid]                    = 362
end

#
# Install
#

default[:mongodb][:version]                         = "2.2.1"
default[:mongodb][:i686][:release_file_md5]         = "21153b201cad912c273d754b02eba19b"
default[:mongodb][:i686][:release_url]              = "http://fastdl.mongodb.org/linux/mongodb-linux-i686-2.2.1.tgz"
default[:mongodb][:x86_64][:release_file_md5]       = "6b2cce94194113ebfe2a14bdb84ccd7e"
default[:mongodb][:x86_64][:release_url]            = "http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.2.1.tgz"

#
# Services
#

default[:mongodb][:server][:run_state]              = :start

#
# Tunables
#

default[:mongodb][:server][:mongod_port]            = 27017
default[:mongodb][:server][:bind_ip]                = nil
default[:mongodb][:server][:rest]                   = false
default[:mongodb][:server][:persistent]             = true
