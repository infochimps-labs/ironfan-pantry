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

include_recipe "metachef"

package "nfs-common"
