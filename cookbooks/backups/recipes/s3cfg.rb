# Cookbook Name::       backups
# Description::         Sets up s3cfg file for root user.  
# Recipe::              s3cfg
# Author::              Brandon Bell - Infochimps, Inc

package 's3cmd'

template "/etc/s3cfg" do
  owner         "root"
  group         "hadoop"
  source        "s3cfg.erb"
  mode          "0640"
  variables ( { :aws => node[:aws] } ) 
end
