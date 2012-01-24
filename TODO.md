* aws key databag + helper
* cucumber
* hbase
* domain names
* vagrants
* launch machine with blank snapshot

* flume, others should use a components_with helper for adding confs

* mount home drive immediately

* volumes don't deep merge -- eg you have to mount_ephemerals in the facet if you modify htem



zabbix:

* apache should not install
* currently requires
  - nginx, apache, firewall, openssl, mysql, database, postgresql, ufw, iiptables
* should not contact zabbix server during run
* use standard directories, not /opt/...
* use discovery not raw search
* separate out target selection (this node vs. discovered node) from providing

### reorg

* symlinks in cookbooks
  - users cookbook
  - infochimps_chef roles

* knife/bootstrap

* cluster_chef gem


### Cookbook attribute refresh:

                          | flip fixed | temujin9 checked |
                          +------------+------------------+
        cassandra	  |            |                  |
        ec2               |            |                  |
        elasticsearch	  |            |                  |
        firewall	  |            |                  |
        flume             |            |                  |
        ganglia           |            |                  |
        graphite	  |            |                  |
        hadoop_cluster	  |            |                  |
        hbase             |            |                  |
        hive              |            |                  |
        jenkins           |            |                  |
        jruby             |            |                  |
        nfs               |            |                  |
        nodejs            |            |                  |
        papertrail	  |            |                  |
        pig               |            |                  |
        redis             |            |                  |
        resque            |            |                  |
        Rstats            |            |                  |
        statsd            |            |                  |
        zookeeper	  |            |                  |
        # meta:
        install_from	  |            |                  |
        motd              |            |                  |
        mountable_volumes |            |                  |
        provides_service  |            |                  |
        # Need thinkin':
        big_package	  |            |                  |
        cluster_chef      |            |                  |


### std cookbooks

#### integration

* apt: has a dashboard at http://{hostname}:3142/report

### Cookbook Munger

* update to-from comments in attributes.rb
