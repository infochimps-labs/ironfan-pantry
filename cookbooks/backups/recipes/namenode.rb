# Cookbook Name::       backups
# Description::         Cron job to take backups of namenode edit logs and fsimage
# Recipe::              namenode
# Author::              Brandon Bell - Infochimps, Inc

package 'curl'
include_recipe "backups::s3cfg"

# Backups 
template "/usr/local/sbin/#{node[:backups][:namenode][:cluster_name]}_namenode_backup.sh" do
  source        "namenode_backup.sh.erb"
  mode          "0744"
  variables(:namenode_fqdn => (discover(:hadoop, :namenode) && discover(:hadoop, :namenode).private_hostname)) 
end

cron "namenode metatadata backup" do
  minute	node[:backups][:namenode][:minute]
  hour		node[:backups][:namenode][:hour]
  day		node[:backups][:namenode][:day]
  month		node[:backups][:namenode][:month]
  weekday	node[:backups][:namenode][:weekday]
  command	"/usr/local/sbin/#{node[:backups][:namenode][:cluster_name]}_namenode_backup.sh >> /tmp/#{node[:backups][:namenode][:cluster_name]}_namenode_backup.$(date +\\%Y\\%m\\%d).out 2>&1"
end

# Cleanup 
template "/usr/local/sbin/#{node[:backups][:namenode][:cluster_name]}_namenode_s3_cleanup.sh" do
  source        "s3_cleanup.sh.erb"
  mode          "0744"
  variables(:retention => node[:backups][:retention][:namenode], :type => "namenode")
end

cron "namenode s3 cleanup" do
  minute        node[:backups][:retention][:minute]
  hour          node[:backups][:retention][:hour]
  day           node[:backups][:retention][:day]
  month         node[:backups][:retention][:month]
  weekday       node[:backups][:retention][:weekday]
  command       "/usr/local/sbin/#{node[:backups][:namenode][:cluster_name]}_namenode_s3_cleanup.sh >> /tmp/#{node[:backups][:namenode][:cluster_name]}_namenode_s3_cleanup.$(date +\\%Y\\%m\\%d).out 2>&1"
end
