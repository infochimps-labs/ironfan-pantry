# ebs_migrate chef cookbook

## Overview

A set of scripts to create volumes from a snapshot and attach them to a live EC2 instance.  Ultimately, this can be used to 'refresh' test or staging servers and clusters from snapshots of production.  

Tags are carried over and chef-client is finally ran to attach the volume and take care of restarting any daemons.  

## Recipes 

* `default`                  - Place holder
* `elasticsesarch`           - Sets up shell script to stop ES, umount drive, detach volume, create and reattach volume from snapshot.
* `migrate`                  - Takes care of the EC2 volume tagging, creation, etc.  

## Integration

* EBS Snapshots tagged correctly.  See backups::ebs

## Attributes

* `[:ebs_migrate][:ebs]`              - The EBS volume you are going to replace.  This is typically defined using 'volumes'
* `[:ebs_migrate][:target]`           - The target cluster and facet you have snapshots of.

* `[:ebs_migrate][:es][:mount_point]` - Mountpoint for the Elasticsearch data.  #FIXME: This is used to force tagging in case of failure
* `[:ebs_migrate][:es][:device]`      - Device the volume is attached as. #FIXME: This is for recovery purposes in failure 
* `[:ebs_migrate][:es][:minute]`      - Cron information. Default : 15
* `[:ebs_migrate][:es][:hour]`        - Default : 02
* `[:ebs_migrate][:es][:day]`         - Default : *
* `[:ebs_migrate][:es][:month]`       - Default : *
* `[:ebs_migrate][:es][:weekday]`     - Default : *

## License and Author

Author::                Brandon Bell - Infochimps, Inc (<coders@infochimps.com>)
Copyright::             Infochimps, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
