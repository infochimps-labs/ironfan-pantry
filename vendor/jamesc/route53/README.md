DESCRIPTION
===========

Automatically configures system DNS using Amazon Route53.

It creates CNAME entries similar to those created in the dynect cookbook


## Getting Started

Assume you are setting up a domain to hold these. Let's call it 'awesomesauce.com'

* In the Amazon Route53 console, create a hosted zone called awesomesauce.com. 
  - Note the NS servers AWS gives you.
  - make a CNAME record ('foo.awesomesauce.com') and point it somewhere identifiable, like 'www.infochimps.com'.
  
* go to your domain registrar and set the hosted zone's NS servers as the domain's NS servers. 
  - WAIT A FEW MINUTES (you don't want to cache an out-of-date entry),
  - then run `host foo.awesomesauce.com`. You should see something like
  
        foo.awesomesauce.com is an alias for www.infochimps.com
        www.infochimps.com has address xx.xx.xx.xx

* In your chef environment, set the default zone. If you don't have anything else in there, it will look like

 	    {"defaults":{"route53":{"zone":"awesomesauce.com"}},"overrides":{}}
        
* Follow the remaining instructions below. Adding `route53::ec2` to a machine 'web_demo-server-3' should give you `web-demo-server-3.awesomesauce.com`.

* If you want to use a subdomain -- so that your machines will be `web-demo-server-3.cloud.awesomesauce.com`, 
  - create a hosted zone `cloud.awesomesauce.com`, and note its nameservers (let's call them 'Y')
  - in the nameserver for `awesomesauce.com`, create NS records pointing to Y. You shouldn't make another SOA record.
  - set `node[:route53][:zone]` to be `cloud.awesomesauce.com` 

REQUIREMENTS
============

Chef 0.8+.

An AWS Route53 account.

The `fog` gem. The `fog::default` recipe installs this gem and its dependencies

ATTRIBUTES
==========

The following attributes need to be set either in a role or on a node directly, they are not set at the cookbook level:

* route53.zone - Zone

Example JSON:

    {
      "route53": {
        "access_key": "SECRET_KEY",
        "secret_key": "ACCESS_KEY",
        "zone": "ZONE",
        "domain": "DOMAIN"
      }
    }

EC2 specific attributes:

* route53.ec2.type - type of system, web, db, etc. Default is 'ec2'.
* route53.ec2.env - logical application environment the system is in. Default is 'prod'.

RESOURCES
=========

route53_rr
--

DNS Resource Record.

Actions:

Applies to the DNS record being managed.

* `:create`
* `:replace`
* `:update`
* `:delete`

Attribute Parameters:

* `zone` - DNS zone
* `name` - fully qualified domain name of entry in zone
* `type` - DNS record type (CNAME, A, etc)
* `values` - Record values.
* `default_ttl` - default time to live in seconds
* `access_key` - dyn username
* `secret_key` - dyn password

None of the parameters have default values.

Example:

    route53_rr "webprod" do
      name       "webprod.#{node.route53.zone}"
      type "A"   values([ "10.1.1.10"])
      ttl        node[:route53][:default_ttl]
      access_key node[:route53][:access_key]
      secret_key node[:route53][:secret_key]
      zone       node[:route53][:zone]
    end

RECIPES
=======

This cookbook provides the following recipes.

default
-------

The default recipe installs the `route53` gem during the Chef run's compile time to ensure it is available in the same run as utilizing the `route53_rr` resource/provider.

ec2
---

**Only use this recipe on Amazon AWS EC2 hosts!**

The `route53::ec2` recipe provides an example of working with the Route53 API with EC2 instances. It creates CNAME records based on the EC2 instance ID (`node.ec2.instance_id`), and a constructed hostname from the route53.ec2 attributes.

The recipe also edits resolv.conf to search compute-1.internal and the route53.domain and use route53.domain as the default domain, and it will set the nodes hostname per the DNS settings.

a_record
--------

The `route53::a_record` recipe will create an `A` record for the node using the detected hostname and IP address from `ohai`.


FURTHER READING
===============

Information on the Amazon Route53 API:

* [HTML](http://docs.amazonwebservices.com/Route53/latest/APIReference/), [PDF](http://awsdocs.s3.amazonaws.com/Route53/latest/route53-api.pdf)

Route53 Library by Philip Corliss

* [Gem](http://rubygems.org/gems/route53)
* [Code](http://github.com/pcorliss/ruby_route_53 )


LICENSE AND AUTHOR
==================


- Author: James Casey (<jamesc.000@gmail.com>)
- Copyright: 2010, Platform14.com.

Based on dynect cookbook,

- Original Author: Adam Jacob (<adam@opscode.com>)
- Original Copyright: 2010, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
