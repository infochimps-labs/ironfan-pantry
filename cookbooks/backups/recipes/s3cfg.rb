# Cookbook Name::       backups
# Description::         Sets up s3cfg file for root user.  
# Recipe::              s3cfg
# Author::              Brandon Bell - Infochimps, Inc

package 's3cmd'

template "/root/.s3cfg" do
  source        "s3cfg.erb"
  mode          "0600"
  variables ( { :aws => node[:aws] } ) 
end
