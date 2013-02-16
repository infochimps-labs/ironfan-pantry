# Cookbook Name::       backups
# Description::         Backup zookeeper txlog and snapshot.  
# Recipe::              zookeeper
# Author::              Brandon Bell - Infochimps, Inc

include_recipe "backups::s3cfg"

template "/usr/local/sbin/#{node[:backups][:zookeeper][:cluster_name]}_zookeeper_backup.sh" do
  source        "zookeeper_backup.sh.erb"
  mode          "0744"
end

cron "zookeeper backups" do
  minute	node[:backups][:zookeeper][:minute]
  hour		node[:backups][:zookeeper][:hour]
  day		node[:backups][:zookeeper][:day]
  month		node[:backups][:zookeeper][:month]
  weekday	node[:backups][:zookeeper][:weekday]
  command	"/usr/local/sbin/#{node[:backups][:zookeeper][:cluster_name]}_zookeeper_backup.sh >> /tmp/#{node[:backups][:zookeeper][:cluster_name]}_zookeeper_backup.$(date +\\%Y\\%m\\%d).out 2>&1"
end

# Cleanup 
template "/usr/local/sbin/#{node[:backups][:zookeeper][:cluster_name]}_zookeeper_s3_cleanup.sh" do
  source        "s3_cleanup.sh.erb"
  mode          "0744"
  variables(:retention => node[:backups][:retention][:zookeeper], :type => "zookeeper")
end

cron "zookeeper s3 cleanup" do
  minute        node[:backups][:retention][:minute]
  hour          node[:backups][:retention][:hour]
  day           node[:backups][:retention][:day]
  month         node[:backups][:retention][:month]
  weekday       node[:backups][:retention][:weekday]
  command       "/usr/local/sbin/#{node[:backups][:zookeeper][:cluster_name]}_zookeeper_s3_cleanup.sh >> /tmp/#{node[:backups][:zookeeper][:cluster_name]}_zookeeper_s3_cleanup.$(date +\\%Y\\%m\\%d).out 2>&1"
end

