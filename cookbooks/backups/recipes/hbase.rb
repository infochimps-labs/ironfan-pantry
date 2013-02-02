# Cookbook Name::       backups
# Description::         Cron job incrimentally backs up hbase tables to S3
# Recipe::              backup_tables
# Author::              Brandon Bell - Infochimps, Inc

include_recipe 'backups::s3cfg'
include_recipe 'hadoop_cluster::config_files'
include_recipe 'hbase::default'
include_recipe 'hbase::config_files'

template "/usr/local/sbin/#{node[:backups][:hbase][:cluster_name]}_table_backups.sh" do
  source        "hbase_tables_to_s3.sh.erb"
  mode          "0744"
end

cron "hbase table backup" do
  minute        node[:backups][:hbase][:minute]
  hour          node[:backups][:hbase][:hour]
  day           node[:backups][:hbase][:day]
  month         node[:backups][:hbase][:month]
  weekday       node[:backups][:hbase][:weekday]
  command       "/usr/local/sbin/#{node[:backups][:hbase][:cluster_name]}_table_backups.sh"
end

