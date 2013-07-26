# Cookbook Name::       s3cmd
# Description::         Sets up s3cmd with global configuration.  
# Recipe::              default
# Author::              Brandon Bell - Infochimps, Inc

include_recipe 'aws'

package 's3cmd'
config = "#{node[:s3cmd][:config][:file]}"

template config do
  owner         "#{node[:s3cmd][:config][:owner]}"
  group         "#{node[:s3cmd][:config][:group]}"
  source        "s3cfg.erb"
  mode          "#{node[:s3cmd][:config][:mode ]}"
  variables ( { :aws => node[:aws] } ) 
end
