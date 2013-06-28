#
# Cookbook Name:: ebs_migrate
# Description:: Migrate script.  This takes care of volume detach, snapshot clone, volume attach, and tagging.  
# Recipe:: elasticsearch
# Author:: Brandon Bell - Infochimps, Inc

include_recipe "ebs_migrate::migrate"

template "/usr/local/sbin/elasticsearch_ebs_migrate.sh" do
  source        "elasticsearch.sh.erb"
  mode          "0744"
end

cron "elasticsearch ebs migrate" do
  minute        node[:ebs_migrate][:es][:minute]
  hour          node[:ebs_migrate][:es][:hour]
  day           node[:ebs_migrate][:es][:day]
  month         node[:ebs_migrate][:es][:month]
  weekday       node[:ebs_migrate][:es][:weekday]
  command       "/usr/local/sbin/elasticsearch_ebs_migrate.sh >> /tmp/elasticsearch_ebs_migrate.$(date +\\%Y\\%m\\%d).out 2>&1"
end

