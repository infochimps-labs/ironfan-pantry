#
# Cookbook Name:: ebs_migrate
# Description:: This takes care of unmounting, detach, create, and attach of the volume.  Tagging as well
# Recipe:: elasticsearch
# Author:: Brandon Bell - Infochimps, Inc

template "/usr/local/sbin/ebs_migrate.rb" do
  source        "ebs_migrate.rb.erb"
  mode          "0744"
  variables ( { :aws => node[:aws] } )
end
