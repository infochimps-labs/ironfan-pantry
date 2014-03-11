#
# Cookbook Name::       kafka
# Description::         Install From Release
# Recipe::              install_from_release
# Author::              Logan Lowell, Josh Bronson, Infochimps
#
# Copyright 2012 Infochimps
#

include_recipe 'install_from'

daemon_user 'kafka'

install_from_release(:kafka) do
  release_url   node[:kafka][:release_url]
  version       node[:kafka][:version]
  checksum      node[:kafka][:checksum]
  action        [:build_with_sbt, :install]
end

include_recipe 'kafka::install_common'
