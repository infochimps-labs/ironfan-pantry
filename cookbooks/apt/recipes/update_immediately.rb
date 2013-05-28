#
# Cookbook Name:: apt
# Recipe:: update_immediately
#
# Copyright 2013, Infochimps, Inc.

execute("apt-get update"){ action :nothing }.run_action(:run)
