Hooray! there is a burndown list
Yikes! It's long. Luckily we are badasses. Comments and assitance welcome.

## Must Do

* ~~sync infochimps-labs/opscode-cookbooks with opscode/cookbooks (Flip)~~
* merge volumes into silverware. merge ebs_volumes into ec2 cookbook (Flip)
* Basic CI testing of cookbooks (Flip)
* RSpecs for silverback (lib and knife tools) (Flip)
* RSpecs for silverware are mostly in place -- ensure they are. (Flip)
* ~~Raid is having problems (race conditions in converge/configure with mounting)-  (Flip)~~
* Git deploy abstraction similar to `install_from` (Flip)
* version bump all cookbooks (Nathan)
* push cookbooks to community.opscode.com  (Flip)
* sync cookbooks up/down to `infochimps-cookbooks/` 
  - note: infochimps-cookbooks the org will be dereferenced in favor of ironfan-lib the single repo; it's unclear which pull requesters will prefer. We will do at least one push so that names and URLs are current, and we're not removing anything, but infochimps-cookbooks has an unclear future.
* refactor homebase setup into easier-to-maintain structure (Nathan)

## Docco
(Selene)

* Clean up README file in homebase, silverware and cluster_chef
* Clear description of metadiscovery
* organize homebase/notes (and decide where it goes). There’s some cruft in there that should leave
* make sure README files in cookbooks aren’t wildly inaccurate
* Carry out setup directions, ensure they work:
* cluster_chef if you’re using our homebase
* cluster_chef if you’re using opscode’s homebase
* local vagrant environment 
* hadoop cluster bootstrapping
* `ironfan install` checks everything out

## Piddly Shit

* standardize the `zabbix` cookbook (no more /opt, etc -- more in the TODO)
* volumes don't deep merge -- eg you have to mount_ephemerals in the facet if you modify htem
* kill_old_service should disable services (may be leaving /etc/rc.d cruft).
* kill old service doesn't go the first time. why?
* in something somewhere: “WARN: Missing gem ‘right_aws’, ‘fog’, ‘rvm’”
* chef client/server cookbook: set chef user UID / GID; client can set log directory
* apt has a dashboard at http://{hostname}:3142/report
* cluster_chef#101: fog can fail to create tags
* cluster_chef#98: flume master should not announce as zookeeper
* cluster_chef#93: not quite so opinionated about keypairs
* cluster_chef#91: probably fixed -- regions
* cluster_chef#87: probably fixed -- can create ebs volumes at launch with no snapshot
* cluster_chef#86: patch available -- security groups with mixed case
* cluster_chef#81: probably fixed -- cassandra cookbook
* cluster_chef#76: knife cluster kick should work even if service not running
* cluster_chef#67: probably fixed
* cluster_chef#48: bootstrap with elastic_ip
* cluster_chef#10: cookbook checklist
* can use knife ssh as me@ or as ubuntu@
* knife command to set/remove permanent on a node + disableApiTermination on box. knife cluster kill refuses to delete nodes with permanent set. knife cluster sync sets permanent on if permanent(true), removes if permanent(false), ignores if permanent nil or unset. 
* rip out `cookbook_munger`
* rip out `repo_man`

## Really Want

* unify the hashlike underpinning to be same across silverware & cluster_chef. Make sure we love (or accept) all the differences between it and Gorrillib’s, and between it and Chef’s.
* Route 53
* Keys are transmitted in databags, using a helper, and not in node attributes
* easy to create a dummy node (load balancer, external resource, etc)
* cookbook munger reads comments in attributes file to populate metadata.rb
* components can have arbitrary attributes
* All cookbooks have nice detailed announcements
* full roll out of log_integration, monitoring
* Rakefile becomes skinnier

## Cookbook checklist:
(Nathan)

* Validate all the cookbooks against checklist -- see notes/README-checklist.md 

                          | flip fixed | temujin9 checked |
                          +------------+------------------+
        cassandra    	  |            |                  |
        ec2               |            |                  |
        elasticsearch	  |            |                  |
        firewall     	  |            |                  |
        flume             |            |                  |
        ganglia           |            |                  |
        graphite     	  |            |                  |
        hadoop_cluster	  |            |                  |
        hbase             |            |                  |
        hive              |            |                  |
        jenkins           |            |                  |
        jruby             |            |                  |
        nfs               |            |                  |
        nodejs            |            |                  |
        papertrail   	  |            |                  |
        pig               |            |                  |
        redis             |            |                  |
        resque            |            |                  |
        Rstats            |            |                  |
        statsd            |            |                  |
        zookeeper    	  |            |                  |
        # meta:
        install_from	  |            |                  |
        motd              |            |                  |
        mountable_volumes |            |                  |
        provides_service  |            |                  |
        # Need thinkin':
        big_package  	  |            |                  |
        cluster_chef      |            |                  |


## Things that are probably straightforward to fix as soon as we know how

* announcements should probably be published very early, but they need to know lots about the machine YUK
* split between clusters / roles / integration cookbooks
* inheritance of clusters

## Things We Hate But Might Have to Continue Hating

* Cluster refactor -- clusters / stacks / components, not clusters / roles / cookbooks
* move cluster discovery to cloud class.
* Server#normalize! doesn’t imprint object (ie. server attributes poke through to the facet & cluster, rather than being *set* on the object)
* The fact you can only see one cluster at a time is stupid.
* security group pairing is sucky.
* ubuntu home drive bullshit
* Finer-grained security group control (eg nfs server only opens a couple ports, not all)
* nfs recipe uses discovery right (thus allowing more than one NFS share to exist in the universe)
* roles UGGGHHHHAERWSDFKHSBLAH

## Ponies!

* foodcritic compatibility
* build out cookbook munger, make it less spike-y
* spot pricing
* rackspace compatibility
