# Cookbook Name::       backups
# Description::         Backup Elasticsearch Indexes and Mappings
# Recipe::              elasticsearch
# Author::              Brandon Bell - Infochimps, Inc

include_recipe "backups::s3cfg"
include_recipe "elasticsearch::client"

%w[esbackup.class].each do |fname|
  cookbook_file "#{node[:elasticsearch][:home_dir]}/lib/#{fname}" do
    source fname
    owner "root"
    mode  "0644"
  end
end

template "/usr/local/sbin/#{node[:backups][:elasticsearch][:cluster_name]}_elasticsearch_backup.sh" do
  source        "elasticsearch_backup.sh.erb"
  mode          "0744"
  variables(:elasticsearch_hosts => ( discover_all(:elasticsearch, :server).map{|svr| svr.node[:ipaddress] } ) )
end

cron "elasticsearch backups" do
  minute	node[:backups][:elasticsearch][:minute]
  hour		node[:backups][:elasticsearch][:hour]
  day		node[:backups][:elasticsearch][:day]
  month		node[:backups][:elasticsearch][:month]
  weekday	node[:backups][:elasticsearch][:weekday]
  command	"/usr/local/sbin/#{node[:backups][:elasticsearch][:cluster_name]}_elasticsearch_backup.sh"
end

cron "elasticsearch s3 cleanup" do
  minute        node[:backups][:retention][:minute]
  hour          node[:backups][:retention][:hour]
  day           node[:backups][:retention][:day]
  month         node[:backups][:retention][:month]
  weekday       node[:backups][:retention][:weekday]
  command       "/usr/local/sbin/#{node[:backups][:elasticsearch][:cluster_name]}_elasticsearch_s3_cleanup.sh >> /tmp/#{node[:backups][:elasticsearch][:cluster_name]}_elasticsearch_s3_cleanup.$(date +\\%Y\\%m\\%d).out 2>&1"
end

