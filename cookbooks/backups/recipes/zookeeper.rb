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
  command	"/usr/local/sbin/#{node[:backups][:zookeeper][:cluster_name]}_zookeeper_backup.sh"
end

