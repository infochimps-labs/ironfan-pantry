# Cookbook Name::       backups
# Description::         Backup Elasticsearch Indexes and Mappings
# Recipe::              elasticsearch
# Author::              Brandon Bell - Infochimps, Inc

include_recipe "backups::s3cfg"

gem_package "tire" do
  action :install
end

template "/usr/local/sbin/#{node[:backups][:elasticsearch][:cluster_name]}_elasticsearch_backup.rb" do
  source        "elasticsearch_idx_to_s3.rb.erb"
  mode          "0744"
  variables(:elasticsearch_host => (discover(:elasticsearch, :server) && discover(:elasticsearch, :server).private_hostname),)
end

cron "elasticsearch backups" do
  minute	node[:backups][:elasticsearch][:minute]
  hour		node[:backups][:elasticsearch][:hour]
  day		node[:backups][:elasticsearch][:day]
  month		node[:backups][:elasticsearch][:month]
  weekday	node[:backups][:elasticsearch][:weekday]
  command	"/usr/local/sbin/#{node[:backups][:elasticsearch][:cluster_name]}_elasticsearch_backup.rb"
end

