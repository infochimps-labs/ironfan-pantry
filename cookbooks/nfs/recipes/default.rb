#
# Cookbook Name::       nfs
# Description::         Base configuration for nfs
# Recipe::              default
# Author::              37signals
#
# Copyright 2011, 37signals
#
# (no license specified)
#

include_recipe 'silverware'

nfs_package =
  case node[:platform]
  when 'centos'           then 'nfs-utils'
  when 'debian', 'ubuntu' then 'nfs-common'
  else                          nil
  end
package(nfs_package){action :nothing}.run_action(:install) if nfs_package
