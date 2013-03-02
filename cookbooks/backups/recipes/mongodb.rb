# Cookbook Name::       backups
# Description::         Cron job to take backups of MongoDB
# Recipe::              mongodb
# Author::              Brandon Bell - Infochimps, Inc

include_recipe "mongodb::install_from_release"
include_recipe "backups::s3cfg"

# Backups 
template "/usr/local/sbin/mongodb_backup.sh" do
  source        "mongodb_backup.sh.erb"
  mode          "0744"
  variables(:mongodb_fqdn => (discover(:mongodb, :server) && discover(:mongodb, :server).private_hostname)) 
end

cron "mongodb backup" do
  minute	node[:backups][:mongodb][:minute]
  hour		node[:backups][:mongodb][:hour]
  day		node[:backups][:mongodb][:day]
  month		node[:backups][:mongodb][:month]
  weekday	node[:backups][:mongodb][:weekday]
  command	"/usr/local/sbin/mongodb_backup.sh >> /tmp/mongodb_backup.$(date +\\%Y\\%m\\%d).out 2>&1"
end

# Cleanup 
template "/usr/local/sbin/mongodb_s3_cleanup.sh" do
  source        "s3_cleanup.sh.erb"
  mode          "0744"
  variables(:retention => node[:backups][:retention][:mongodb], :type => "mongodb")
end

cron "mongodb s3 cleanup" do
  minute        node[:backups][:retention][:minute]
  hour          node[:backups][:retention][:hour]
  day           node[:backups][:retention][:day]
  month         node[:backups][:retention][:month]
  weekday       node[:backups][:retention][:weekday]
  command       "/usr/local/sbin/mongodb_s3_cleanup.sh >> /tmp/mongodb_s3_cleanup.$(date +\\%Y\\%m\\%d).out 2>&1"
end
