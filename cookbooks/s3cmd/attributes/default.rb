#
# s3cmd
#

default[:s3cmd][:config][:file ] = "/etc/s3cfg" # Location for s3cmd config file

default[:s3cmd][:config][:owner] = "root"
default[:s3cmd][:config][:group] = "admin"
default[:s3cmd][:config][:mode ] = "0640"
