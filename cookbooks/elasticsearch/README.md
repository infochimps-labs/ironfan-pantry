# elasticsearch chef cookbook

Elasticsearch: a distributed full-text search database based on Lucene. You know, for search

* Cookbook source:   [http://github.com/infochimps-cookbooks/elasticsearch](http://github.com/infochimps-cookbooks/elasticsearch)
* Ironfan tools: [http://github.com/infochimps-labs/ironfan](http://github.com/infochimps-labs/ironfan)
* Homebase (shows cookbook in use): [http://github.com/infochimps-labs/ironfan-homebase](http://github.com/infochimps-labs/ironfan-homebase)

## Overview

= THIS IS THE INFOCHIMPS VERSION

= DESCRIPTION:

Installs and configures ElasticSearch.

= REQUIREMENTS:

== Platform:

Tested on Ubuntu 9.10 on EC2 only. YMMV on other platforms.

==Cookbooks:

Requires Opscode's runit and java cookbooks.  

= ATTRIBUTES:

It's a good idea to change the cluster_name attribute to something 
meaningful, like "production".

Production deployments should also increase the java_heap_size_max and fd_ulimit 
attributes.

To use the s3 gateway, set the s3_gateway_bucket attribute to the name of an 
existing bucket. You'll also need to add aws credentials to the aws databag 
(see below)

= USAGE:

This cookbook makes a few assumptions about where files live:

/etc/elasticsearch: configuration files
/var/lib/elasticsearch: elasticsearch runtime files
/var/log/elasticsearch: elasticsearch log directory

Use elasticsearch::autoconf to automatically discover nodes in the cluster. Use 
elasticsearch for a more static deployment.

Both options will configure ElasticSearch and start the ElasticSearch runit 
service.

To use the s3 gateway, add your s3 credentials to a databag item with id "main" 
in the "aws" databag. The schema of this item is:
{
  "aws_access_key_id":
  "aws_secret_access_key":
  "aws_account_id":
  "ec2_cert":
  "ec2_private_key":
}

= LICENSE and AUTHOR:

Author:: Grant Rodgers (<grant@gotime.com>)

Copyright:: 2010, GoTime Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## Recipes 

* `client`                   - Client
* `config`                   - Finalizes the config, writes out the config files
* `default`                  - Base configuration for elasticsearch
* `install_from_git`         - Install From Git
* `install_from_release`     - Install From Release
* `plugins`          - Install Plugins
* `load_balancer`            - Load Balancer
* `server`                   - Server

## Integration

Supports platforms: debian and ubuntu

Cookbook dependencies:

* java
* runit
* aws
* volumes
* tuning
* silverware
* install_from


## Attributes

* `[:elasticsearch][:version]`        -  (default: "1.1.1")
* `[:elasticsearch][:realm]`        -  (default: cluster name)
* `[:elasticsearch][:data_dir]`      -  (default: nil)
* `[:elasticsearch][:scratch_dir]`     -  (default: nil)
* `[:elasticsearch][:java_home]`      -  (default: "/usr/lib/jvm/java-6-sun/jre")
* `[:elasticsearch][:git_repo]`       -  (default: "https://github.com/elasticsearch/elasticsearch.git")
* `[:elasticsearch][:java_heap_size_max]` -  (default: "1000")
* `[:elasticsearch][:ulimit_mlock]`   - 
* `[:elasticsearch][:default_replicas]` -  (default: "1")
* `[:elasticsearch][:default_shards]` -  (default: "6")
* `[:elasticsearch][:flush_threshold]` -  (default: "5000")
* `[:elasticsearch][:index_buffer_size]` -  (default: "10%")
* `[:elasticsearch][:merge_factor]`   -  (default: "10")
* `[:elasticsearch][:max_thread_count]` -  (default: "4")
* `[:elasticsearch][:term_index_interval]` -  (default: "128")
* `[:elasticsearch][:refresh_interval]` -  (default: "1s")
* `[:elasticsearch][:snapshot_interval]` -  (default: "-1")
* `[:elasticsearch][:snapshot_on_close]` -  (default: "false")
* `[:elasticsearch][:seeds]`          - 
* `[:elasticsearch][:recovery_after_nodes]` -  (default: "2")
* `[:elasticsearch][:recovery_after_time]` -  (default: "5m")
* `[:elasticsearch][:expected_nodes]` -  (default: "2")
* `[:elasticsearch][:fd_ping_interval]` -  (default: "2s")
* `[:elasticsearch][:fd_ping_timeout]` -  (default: "60s")
* `[:elasticsearch][:fd_ping_retries]` -  (default: "6")
* `[:elasticsearch][:jmx_dash_port]`  -  (default: "9400-9500")
* `[:elasticsearch][:release_url_checksum]` - 
* `[:elasticsearch][:home_dir]`       -  (default: "/usr/local/share/elasticsearch")
* `[:elasticsearch][:conf_dir]`       -  (default: "/etc/elasticsearch")
* `[:elasticsearch][:log_dir]`        -  (default: "/var/log/elasticsearch")
* `[:elasticsearch][:lib_dir]`        -  (default: "/var/lib/elasticsearch")
* `[:elasticsearch][:pid_dir]`        -  (default: "/var/run/elasticsearch")
* `[:elasticsearch][:user]`           -  (default: "elasticsearch")
* `[:elasticsearch][:release_url]`    -  (default: "https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-:version:.tar.gz")
* `[:elasticsearch][:plugins]`        - 
* `[:elasticsearch][:http_ports]`     -  (default: "9200-9300")
* `[:elasticsearch][:api_port]`       -  (default: "9300")
* `[:elasticsearch][:proxy_port]`     -  (default: "8200")
* `[:elasticsearch][:proxy_hostname]` -  (default: "elasticsearch.yourdomain.com")
* `[:elasticsearch][:log_level][:default]` -  (default: "DEBUG")
  - most of the log lines are manageable at level 'DEBUG'
    the voluminous ones are broken out separately
* `[:elasticsearch][:log_level][:index_store]` -  (default: "INFO")
* `[:elasticsearch][:log_level][:action_shard]` -  (default: "INFO")
* `[:elasticsearch][:log_level][:cluster_service]` -  (default: "INFO")
* `[:elasticsearch][:server][:run_state]` -  (default: "stop")
* `[:users][:elasticsearch][:uid]`    -  (default: "61021")
* `[:groups][:elasticsearch][:gid]`   -  (default: "61021")
* `[:tuning][:ulimit][:@elasticsearch]` - 

## License and Author

Author::                GoTime, modifications by Infochimps (<ops@gotime.com>)
Copyright::             2011, GoTime, modifications by Infochimps

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

> readme generated by [ironfan](http://github.com/infochimps-labs/ironfan)'s cookbook_munger
