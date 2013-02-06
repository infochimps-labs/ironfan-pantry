# Cookbook Name::       backups
# Description::         Cron job incrimentally backs up hbase tables to S3
# Recipe::              backup_tables
# Author::              Brandon Bell - Infochimps, Inc

include_recipe 'hadoop_cluster::config_files'
include_recipe 'hbase::default'
include_recipe 'hbase::config_files'

template "#{node[:backups][:hbase][:conf]}" do
  source	"hbase_backup.yaml.erb"
  mode		"0744"
end

template "/usr/local/sbin/#{node[:backups][:hbase][:cluster_name]}_table_backups.rb" do
  source        "hbase_backups.rb.erb"
  mode          "0755"
end

cron "hbase table backup" do
  user		"hdfs"
  minute        node[:backups][:hbase][:minute]
  hour          node[:backups][:hbase][:hour]
  day           node[:backups][:hbase][:day]
  month         node[:backups][:hbase][:month]
  weekday       node[:backups][:hbase][:weekday]
  command       "/usr/local/sbin/#{node[:backups][:hbase][:cluster_name]}_table_backups.rb"
end

