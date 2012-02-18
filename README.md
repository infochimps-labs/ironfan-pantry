# Ironfan-Pantry: Infochimps' battle-hardened collection of Chef cookbooks

The ironfan project is an expressive toolset for constructing scalable, resilient architectures. It works in the cloud, in the data center, and on your laptop, and makes your system diagram visible and inevitable.

This repo holds Infochimps' battle-hardened collection of Chef cookbooks. Some are by us, some are forks, some are dupes. See the CREDITS below.

To get started with ironfan, clone the [homebase repo](https://github.com/infochimps-labs/ironfan-homebase) and follow the [installation instructions](https://github.com/infochimps-labs/ironfan/wiki/install). Please file all issues on [ironfan issues](https://github.com/infochimps-labs/ironfan/issues).

## Index

ironfan-pantry works together with the full ironfan toolset:

* [ironfan-homebase](https://github.com/infochimps-labs/ironfan-homebase): centralizes the cookbooks, roles and clusters. A solid foundation for any chef user.
* [ironfan gem](https://github.com/infochimps-labs/ironfan): core ironfan models, and knife plugins to orchestrate machines and coordinate truth among you homebase, cloud and chef server.
* [ironfan-pantry](https://github.com/infochimps-labs/ironfan-pantry): Our collection of industrial-strength, cloud-ready recipes for Hadoop, HBase, Cassandra, Elasticsearch, Zabbix and more.
* [silverware cookbook](https://github.com/infochimps-labs/ironfan-homebase/tree/master/cookbooks/silverware): coordinate discovery of services ("list all the machines for `awesome_webapp`, that I might load balance them") and aspects ("list all components that write logs, that I might logrotate them, or that I might monitor the free space on their volumes".
* [ironfan-ci](https://github.com/infochimps-labs/ironfan-ci): Continuous integration testing of not just your cookbooks but your *architecture*.

* [ironfan wiki](https://github.com/infochimps-labs/ironfan/wiki): high-level documentation and install instructions
* [ironfan issues](https://github.com/infochimps-labs/ironfan/issues): bugs, questions and feature requests for *any* part of the ironfan toolset.
* [ironfan gem docs](http://rdoc.info/gems/ironfan): rdoc docs for ironfan

## Credits

* [homebrew cookbook](https://github.com/mathie/chef-homebrew) by @mathie
* [jenkins cookbook](https://github.com/fnichol/chef-jenkins) by @fnichol
* [rvm cookbook](https://github.com/fnichol/rvm) by @fnichol
* [mongodb cookbook](https://github.com/infochimps-cookbooks/mongodb) by @papercavalier (though he doesn't seem to be maintaining it no more)
* [nfs cookbook](https://github.com/37signals/37s_cookbooks/tree/master/nfs) heavily modified from the @37signals original
* [cassandra cookbook](https://github.com/b/cookbooks/tree/cassandra/cassandra) modified from @b's original
* [redis cookbook](https://github.com/b/cookbooks/tree/cassandra/cassandra) heavily modified from @b's original
* [elasticsearch cookbook](http://community.opscode.com/cookbooks/elasticsearch) heavily modified from GoTime's original
* [papertrail cookbook](https://github.com/infochimps-cookbooks/papertrail) contributed by Mike Heffner
* [zabbix cookbook](http://community.opscode.com/cookbooks/zabbix) heavily modified from @laradji's original
