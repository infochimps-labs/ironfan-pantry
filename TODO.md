* aws key databag + helper
* cucumber
* hbase
* domain names
* vagrants
* launch machine with blank snapshot

* flume, others should use a components_with helper for adding confs

* mount home drive immediately

* volumes don't deep merge -- eg you have to mount_ephemerals in the facet if you modify htem

* kill_old_service should disable services (may be leaving /etc/rc.d cruft)

* on first run, volumes are not mounted so volumes are not scheduled to resize.
  - fixed, but there is an uncomfortable proliferation of .run_action's going on
  
* kill old service doesn't go the first time


zabbix:

* apache should not install
* currently requires
  - nginx, apache, firewall, openssl, mysql, database, postgresql, ufw, iiptables
* should not contact zabbix server during run
* use standard directories, not /opt/...
* use discovery not raw search
* separate out target selection (this node vs. discovered node) from providing
* zabbix should be in a monitored security group

* The facet that exposes hbase-stargate needs to open the port stargate listens on (8080 by default) to the urza-zabbix facet so that monitoring scripts can work.  This was done by hand this time.
* weatherlight master needs to expose 35862 to zabbix monitoring.

cerulean - flume / royal - cnc / thelonius - zookeeper / clues - hbase / cadet - automated hadoop / miles - science // sod - talks to azure

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
