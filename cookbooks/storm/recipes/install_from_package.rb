#
# Cookbook Name::       storm
# Description::         Install From Package
# Recipe::              install_from_package
# Author::              Erik Mackdanz, Infochimps
#
# Copyright 2012 Infochimps
#

package 'jzmq' do
  options '--force-yes' # Needed for non-GPG chimps repository
  version '1.0' # A deceiving version, built from a git master HEAD
end

daemon_user 'storm'

package 'storm' do
  options '--force-yes' # Needed for non-GPG chimps repository
  version node[:storm][:version]
end

# Ensure storm executable is on path
link '/usr/local/bin/storm' do
  to '/usr/local/share/storm/bin/storm'
end

include_recipe 'storm::install_common'
