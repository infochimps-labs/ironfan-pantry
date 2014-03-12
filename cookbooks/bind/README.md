# Bind [![Build Status](https://secure.travis-ci.org/atomic-penguin/cookbook-bind.png?branch=master)](http://travis-ci.org/atomic-penguin/cookbook-bind)

## Description

A cookbook to manage bind DNS servers, and zones.

## Requirements

Included ldap2zone recipe depends on Chef 0.10.10 features,
such as `chef_gem`.

The net-ldap v0.2.2 Ruby gem is required for the ldap2zone recipe.

## Attributes

### Attributes which probably require tuning

* `bind['masters']`
  - Array of authoritative servers which you transfer zones from.
  - Default empty

* `bind['ipv6_listen']`
  - Boolean, whether BIND should listen on ipv6
  - Default is false

* `bind['acl-role']`
  - Search key for pulling split-domain ACLs out of `data_bags`
  - Defaults to internal-acl, and has no effect if you do not need ACLs.

* `bind['acl']`
  - An array node attribute which `data_bag` ACLs are pushed on to,
    and then passed to named.options template.
  - Default is an empty array.

* `bind['zones']['attribute']`
  - An array attribute where zone names may be set from role
    attributes.  The dynamic source attributes `bind['zones']['ldap']`
    and `bind['zones']['databag']` will be combined with zone names set
    via role attributes before the named.conf template is rendered.

* `bind['zones']['ldap']`
  - An array attribute where zone names may be set from an
    ldap source.

* `bind['zones']['databag']`
  - An array attribute where zone names may be set from a
    databag source.

* `bind['zonetype']`
  - The zone type, master, or slave for configuring
    the  named.conf template.
  - Defaults to slave

* `bind['zonesource']`
  - The external zone data source, included examples are databag
    or ldap
  - Defaults to databag.  Should have no effect if no zone names
    exist in the bind `data_bag`.

* `bind['options']`
  - Free form options for named.conf template
  - Defaults to an empty array.

* `bind['allow_solo_search']`
  - Boolean true/false, enabling chef-solo search
  - Defaults to false

### Attributes which should not require tuning

* `bind['packages']`
  - packages to install
  - Platform specific defaults

* `bind['sysconfdir']`
  - etc directory for named
  - Platform specific defaults

* `bind['conf_file']`
  - Full path to named.conf
  - Platform specific defaults

* `bind['options_file']`
  - Full path to named.options
  - Platform specific defaults

* `bind['vardir']`
  - var directory for named to write state data, such as zone files.
  - Platform specific defaults

* `bind['etc_cookbook_files']`
  - static cookbook files to drop off in sysconf directory
  - Defaults to named.rfc1912.zones

* `bind['etc_template_files']`
  - template files to render from `data_bag` and/or roles
  - Defaults to named.options

* `bind['var_cookbook_files']`
  - static cookbook files to drop off in var directory
  - defaults to named.empty, named.ca, named.loopback, and named.localhost

* `bind['rndc_keygen']`
  - command to generate rndc key
  - default depends on hardware/hypervisor platform

### ldap2zone recipe specific attributes

We store our zone names on Active Directory, and use Ruby to pull
these into Chef and configure our Linux BIND servers.  If you already
have Active Directory, chances are you have an authoritative data
source for zone names in LDAP and can use this recipe to query
this data, just by setting a few attributes in a role.

* `bind['ldap']['binddn']`
   - The binddn username for connecting to LDAP
   - Default nil

* `bind['ldap']['bindpw']`
  - The binddn password for connecting to LDAP
  - Default nil

* `bind['ldap']['filter']`
  - The LDAP object filter for zone names
  - Defaults to dnsZone class, excluding Root DNS Servers

* `bind['ldap'][server']`
  - The authoritative directory server for your domain
  - Defaults to nil

* `bind['ldap']['domainzones']`
  - The LDAP tree where your domain zones are located
  - Defaults to the Active Directory zone tree for example.com.

## Usage

### Notes on the zonesource recipes

The databag2zone and ldap2zone is optional code to fetch DNS zones
from a data bag, or Active Directory integrated domain controllers.
If you have a proper IP address management (IPAM) solution, you
could drop in your own code to query an API on your IPAM server.

Any query should use the `<<` operator to push results on to the
`bind['zones']` array.  Drop your query code in a recipe
named `query2zone.rb`, for example.  Then include the API query
by overriding the attribute `bind['zonesource']` set to the
string `query`.

Alternatively, you can just use an `override['bind']['zones']` in
a role or environment instead.  Or even a mix of both override
attributes, and an API query to populate zones.

### Example role for internal recursing DNS

An example role for an internal split-horizon BIND server for
example.com, might look like so: 

```ruby
name "internal_dns"
description "Configure and install Bind to function as an internal DNS server."
override_attributes "bind" => {
  "acl-role" => "internal-acl",
  "masters" => [ "192.0.2.10", "192.0.2.11", "192.0.2.12" ],
  "ipv6_listen" => true,
  "zonetype" => "slave",
  "zonesource" => "ldap",
  "zones" => [
    "example.com",
    "example.org"
  ],
  "ldap" => {
    "server" => "example.com",
    "binddn" => "cn=chef-ldap,ou=Service Accounts,dc=example,dc=com",
    "bindpw" => "ServiceAccountPassword",
    "domainzones" => "cn=MicrosoftDNS,dc=DomainDnsZones,dc=example,dc=com"
  },
  "options" => [
    "check-names slave ignore;",
    "multi-master yes;",
    "provide-ixfr yes;",
    "recursive-clients 10000;",
    "request-ixfr yes;",
    "allow-notify { acl-dns-masters; acl-dns-slaves; };",
    "allow-query { example-lan; localhost; };",
    "allow-query-cache { example-lan; localhost; };",
    "allow-recursion { example-lan; localhost; };",
    "allow-transfer { acl-dns-masters; acl-dns-slaves; };",
    "allow-update-forwarding { any; };",
  ]
}
run_list "recipe[bind]"
```

### Example role for authoritative only external DNS

An example role for an external split-horizon authoritative only
BIND server for example.com, might look like so:

```ruby
name "external_dns"
description "Configure and install Bind to function as an external DNS server."
override_attributes "bind" => {
  "acl-role" => "external-acl",
  "masters" => [ "192.0.2.5", "192.0.2.6" ],
  "ipv6_listen" => true,
  "zonetype" => "master",
  "zones" => [
    "example.com",
    "example.org"
  ],
  "options" => [
    "recursion no;",
    "allow-query { any; };",
    "allow-transfer { external-private-interfaces; external-dns; };",
    "allow-notify { external-private-interfaces; external-dns; localhost; };",
    "listen-on-v6 { any; };"
  ]
}
run_list "recipe[bind]"
```

### Example BIND Access Controls from data bag

In order to include an external ACL for the private interfaces
of your external nameservers, you can create a data bag like so.

  * data_bag name: bind
    - id: ACL entry name
    - role: search key for bind data_bag
    - hosts: array of CIDR addresses, or IP addresses

```json
{
  "id": "external-private-interfaces",
  "role": "external-acl",
  "hosts": [ "192.0.2.15", "192.0.2.16", "192.0.2.17" ]
}
```

In order to include an internal ACL for the query addresses of
your LAN, you might create a data bag like so.

  * data_bag name: bind
    - id: ACL entry name
    - role: search key for bind data_bag
    - hosts: array of CIDR addresses, or IP addresses

```json
{
  "id": "example-lan",
  "role": "internal-acl",
  "hosts": [ "192.0.2.18", "192.0.2.19", "192.0.2.20" ]
}
```

### Example to load zone names from data bag

If you have a few number of zones, you can split these
up into individual data bag objects if you prefer.

  * data_bag name: bind
    - zone: string representation of individual zone name.

```json
{
  "id": "example",
  "zone": "example.com"
}
```

If you wish to group a number of zones together, you can
use the following format to include a number of zones at once.

  * data_bag name: bind
    - zones: array representation of several zone names.

```json
{
  "id": "example",
  "zones": [ "example.com", "example.org" ]
}
```

## License and Author

Copyright: 2011 Eric G. Wolfe

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
