#
# Cookbook Name:: apt
# Recipe:: update_immediately
#
# Copyright 2013, Infochimps, Inc.

if platform_family? "debian" then
  execute("apt-get update") do 
    action :nothing 
  end.run_action(:run)
end
