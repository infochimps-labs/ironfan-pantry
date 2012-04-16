# Ironfan-Pantry: Infochimps' Battle-Hardened Collection of Chef Cookbooks

Ironfan, the foundation of The Infochimps Platform, is an expressive toolset for constructing scalable, resilient architectures. It works in the cloud, in the data center, and on your laptop, and it makes your system diagram visible and inevitable. Inevitable systems coordinate automatically to interconnect, removing the hassle of manual configuration of connection points (and the associated danger of human error).
For more information about Ironfan and the Infochimps Platform, visit [infochimps.com](http://www.infochimps.com/).

This repo holds Infochimps' battle-hardened collection of Chef cookbooks. Some are by us, some are forks, some are dupes. See the CREDITS below.

## Getting Started

To jump right into using Ironfan, follow our [Installation Instructions](https://github.com/infochimps-labs/ironfan/wiki/INSTALL). For an explanatory tour, check out our [Web Walkthrough](https://github.com/infochimps-labs/ironfan/wiki/walkthrough-web).  Please file all issues on [Ironfan Issues](https://github.com/infochimps-labs/ironfan/issues)

## Index

ironfan-pantry works together with the full Ironfan toolset:


### Tools:

* [ironfan-homebase](https://github.com/infochimps-labs/ironfan-homebase): Centralizes the cookbooks, roles and clusters. A solid foundation for any Chef user.
* [ironfan gem](https://github.com/infochimps-labs/ironfan): The core Ironfan models, and Knife plugins to orchestrate machines and coordinate truth among your homebase, cloud and chef server. 
* [ironfan-pantry](https://github.com/infochimps-labs/ironfan-pantry): Our collection of industrial-strength, cloud-ready recipes for Hadoop, HBase, Cassandra, Elasticsearch, Zabbix and more. 
* [silverware cookbook](https://github.com/infochimps-labs/ironfan-pantry/tree/master/cookbooks/silverware): Helps you coordinate discovery of services ("list all the machines for `awesome_webapp`, that I might load balance them") and aspects ("list all components that write logs, that I might logrotate them, or that I might monitor the free space on their volumes"). Found within the [ironfan-pantry](https://github.com/infochimps-labs/ironfan-pantry).

### Documentation:

* [index of wiki pages](https://github.com/infochimps-labs/ironfan/wiki/_pages)
* [ironfan wiki](https://github.com/infochimps-labs/ironfan/wiki): High-level documentation and install instructions.
* [ironfan issues](https://github.com/infochimps-labs/ironfan/issues): Bugs or questions and feature requests for *any* part of the Ironfan toolset.
* [ironfan gem docs](http://rdoc.info/gems/ironfan): Rdoc docs for Ironfan.
* [Ironfan Screen Cast](http://vimeo.com/37279372)-- build a Hadoop cluster from scratch in 20 minutes.

**Note**: Ironfan is [not compatible with Ruby 1.8](https://github.com/infochimps-labs/ironfan/issues/127). All versions later than 1.9.2-p136 should work fine.

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
