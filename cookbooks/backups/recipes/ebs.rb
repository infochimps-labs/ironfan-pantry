# Cookbook Name::       backups
# Description::         Snapshot EBS Volumes
# Recipe::              ebs
# Author::              Brandon Bell - Infochimps, Inc

template "/usr/local/sbin/ebs_snapshot.rb" do
  source        "ebs_snapshot.rb.erb"
  mode          "0744"
  variables ( { :aws => node[:aws] } )
end

cron "ebs backups" do
  minute        node[:backups][:ebs][:minute]
  hour          node[:backups][:ebs][:hour]
  day           node[:backups][:ebs][:day]
  month         node[:backups][:ebs][:month]
  weekday       node[:backups][:ebs][:weekday]
  command       "/usr/local/sbin/ebs_snapshot.rb >> /tmp/ebs_snapshot.$(date +\\%Y\\%m\\%d).out 2>&1"
end

