#
# EBS Information
#
default[:ebs_migrate][:ebs] = nil         # The EBS volume you want to replace on the current machine
default[:ebs_migrate][:target] = nil      # The target cluster and facet you have snapshots of.  Example : patrick-search

#
# Elasticsearch
#

default[:ebs_migrate][:es][:mount_point]   = nil # This is the mount point of the above ebs volume.  FIXME 
default[:ebs_migrate][:es][:device]        = nil # Device the volume is attached as. This is for recovery purposes in failure  FIXME 
default[:ebs_migrate][:es][:mount_cmd]     = nil # Mount command to run before running chef client. This prevents chef-client timeouts FIXME
default[:ebs_migrate][:es][:minute]        = 15 
default[:ebs_migrate][:es][:hour]          = 02
default[:ebs_migrate][:es][:day]           = '*' 
default[:ebs_migrate][:es][:month]         = '*'
default[:ebs_migrate][:es][:weekday]       = '*'
