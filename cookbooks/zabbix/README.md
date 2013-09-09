# Zabbix Chef Cookbook

Installs/Configures Zabbix server, agent, database, and web frontend.

* Cookbook source:   [http://github.com/infochimps-labs/ironfan-pantry](http://github.com/infochimps-labs/ironfan-pantry)
* Ironfan tools: [http://github.com/infochimps-labs/ironfan](http://github.com/infochimps-labs/ironfan)
* Homebase (shows cookbook in use): [http://github.com/infochimps-labs/ironfan-homebase](http://github.com/infochimps-labs/ironfan-homebase)

## Overview

This cookbook is supports Zabbix >= 2.0.0.

### Zabbix Server

The core of a Zabbix installation is the
[https://www.zabbix.com/documentation/2.0/manual/concepts/server](Zabbix
server), installed with the `zabbix::server` recipe.

The server relies on a (SQL-like) database which can be created with
the `zabbix::database` recipe.  Only MySQL is supported at present.

Since version 2.0.0, Zabbix also provides a
[https://www.zabbix.com/documentation/2.0/manual/concepts/java](Java
gateway) to allow for monitoring Java applications via JMX.  The
`zabbix::server` recipe sets up the Java gateway automatically if the
`node[:zabbix][:java_gateway][:install]` is true (it is by default).

### Zabbix Agent

A Zabbix agent running on each machine you want to monitor is required
and set up by the `zabbix::agent` recipe.

### Zabbix PHP Frontend

Zabbix's PHP frontend is set up using the `zabbix::web` recipe.  The
only supported web server is nginx.

### Zabbix Database

Zabbix requires an (SQL-like) database, installed with the
`zabbix::database` recipe.  The only supported database is MySQL at
the moment.

This recipe also sets up a Zabbix API user on top of the insecure
default user that comes with Zabbix.

## Usage:

In addition to the basic recipes that set up the agent, the server, or
the web frontend, this cookbook contains LWRPs for Zabbix resources
like hosts, host groups, items, & triggers.

These can be used directly in cookbooks to create Zabbix integrations.
Say we're setting up a database and we need to monitor the performance
of a port the database exposes.

        # From my_database/monitoring.rb

        # First we have to make sure we're connecting to the Zabbix API
        connect_to_zabbix_api!

        # Now we can create a host to represent the new database
        zabbix_host "my-database" do
          host_groups ["Foo_Databases"]
          templates   ["Foo_Database_Template"]
          virtual     true # this is not a *real* machine, just a Zabbix host
          action      :create
        end

        # And an item for the host
        zabbix_item "Performance of Foo database connection" do
          host 'my-database'
          key  'tcp_perf,8080'
          value_type :float
          units 's'

          # 'simple' means the Zabbix server executes these checks, as
          #  appropriate for a remote port check
          type :simple

          action :create
        end

        # And now a trigger on the item
        zabbix_trigger "Response time too high on Foo database connection" do
          host 'my-database'
          priority :warning

          # Fire if the item 'tcp_perf,8080' on the host 'my-database' has an
          # 'avg' value over the last '300' seconds that is greater than '2'
          # -- i.e., fire if the average response connection time of the Foo
          # database's portspikes to 2 seconds anytime over the last 5
          # minutes.
          expression "{my-database:tcp_perf,8080.avg(300)>2}"

          action   :create
        end

### TODO:

- Support more platform on agent side centos, windows ?
- Add support for ufw , this way search agent how need to have accces to zabbix_server:10051 <-> zabbix_agent:10050

### CHANGELOG:

0.0.19
	- forked opscode version for an opinionated and Ironfan compatible version
	- allow for either apache/nginx to sit in front of php
	- alert scripts for sending email and SMS
	- resources/providers for hosts, host groups, items, triggers using rubix integration
	- recipe for creating hosts from the current set of chef nodes
	- recipe for creating a pipe at /dev/zabbix for writing dynamically to zabbix

0.0.18
	- Fix sysconfdir to point to /etc/zabbix on recipe server_source 
	- Fix right for folder frontends/php on recipe web
	- Hardcode the PATH of conf file in initscript
	- Agent source need to build on a other folder
	- Add --prefix option to default attributes when using *-source recipe
	
0.0.17
	- Don't mess with te PID, PID are now in /tmp
	
0.0.16 
	- Add depencies for recipe agent_source
	- Add AlertScriptsPath folder and option for server.
	
0.0.15
	- Add firewall magic for communication between client and server
0.0.14
	- Correction on documentation
0.0.13
	- Fix some issue on web receipe.
	
0.0.12 
	- Change default value of zabbix.server.dbpassword to nil

0.0.11
	- Remove mikoomo
	- Still refactoring
	
0.0.10
	- Preparation for multiple type installation and some refactoring
	- Support the installation of a beta version when using the install_method == source and changing the attribute branch

0.0.9
	- Tune of mikoomi for running on agent side.

0.0.8 
	- Fix some major issu
	
0.0.7 
	- Add some love to php value
	- Now recipe mysql_setup populate the database
	- Minor fix
	
0.0.6 
	- Change the name of the web_app to fit the fqdn

## Recipes 

* `agent`                    - Installs and launches Zabbix agent.
* `agent_prebuild`           - Downloads, configures, & launches pre-built Zabbix agent
* `agent_source`             - Downloads, builds, configures, & launches Zabbix agent from source.
* `create_hosts`             - Create Hosts
* `database`                 - Configures Zabbix database.
* `database_mysql`           - Configures Zabbix MySQL database.
* `default`                  - Sets up Zabbix directory structure & user.
* `firewall`                 - Configures firewall access between Zabbix server & agents.
* `server`                   - Installs and launches Zabbix server.
* `server_sends_email`       - Configures Zabbix server to be able to send email via a remote SMTP server.
* `server_sends_texts`       - Configures Zabbix server to be able to send texts using Twilio.
* `server_source`            - Downloads, builds, configures, & launches Zabbix server from source.
* `web`                      - Configures PHP-driven, reverse-proxied Zabbix web frontend.
* `web_apache`               - Configures PHP-driven, reverse-proxied Zabbix web frontend using Apache.
* `web_nginx`                - Configures PHP-driven, reverse-proxied Zabbix web frontend using nginx.

## Integration

Supports platforms: debian and ubuntu

Cookbook dependencies:

* apache2
* nginx
* database, >= 1.0.0
* mysql, >= 1.2.0
* ufw, >= 0.6.1
* silverware


## Attributes

* `[:zabbix][:home_dir]`              -  (default: "/usr/local/share/zabbix")
  - The base installation directory for Zabbix.
* `[:zabbix][:host_groups]`           - 
  - Host groups for this node in Zabbix.
* `[:zabbix][:templates]`             - 
  - Templates for this node in Zabbix.
* `[:zabbix][:user]`                  -  (default: "zabbix")
* `[:zabbix][:agent][:servers]`       - 
  - Hostnames/IPs of servers the Zabbix agent will accept connections from.
* `[:zabbix][:agent][:configure_options]` - 
  - Options passed to ./configure script when building agent.
* `[:zabbix][:agent][:branch]`        -  (default: "ZABBIX%20Latest%20Stable")
  - Name of the Zabbix branch to use.
* `[:zabbix][:agent][:version]`       -  (default: "1.8.5")
  - Version of the Zabbix agent to install.
* `[:zabbix][:agent][:install_method]` -  (default: "prebuild")
  - How to install the Zabbix agent: 'prebuild' or 'source'.
* `[:zabbix][:agent][:log_dir]`       -  (default: "/var/log/zabbix_agent")
  - The log directory for the Zabbix agent.
* `[:zabbix][:agent][:create_host]`   -  (default: "true")
  - Whether to create a Zabbix host for this node.
* `[:zabbix][:server][:version]`      -  (default: "1.8.8")
  - The version of the Zabbix server to install.
* `[:zabbix][:server][:branch]`       -  (default: "ZABBIX%20Latest%20Stable")
  - Name of the Zabbix branch to use.
* `[:zabbix][:server][:install_method]` -  (default: "source")
  - How to install the zabbix server: source.
* `[:zabbix][:server][:configure_options]` - 
  - Options passed to the ./configure script when building the Zabbix server.
* `[:zabbix][:server][:log_dir]`      -  (default: "/var/log/zabbix_server")
  - The log directory for the Zabbix server.
* `[:zabbix][:database][:install_method]` -  (default: "mysql")
  - Method of installing the database: only 'mysql'.
* `[:zabbix][:database][:host]`       -  (default: "localhost")
  - Host for the Zabbix database server.
* `[:zabbix][:database][:port]`       -  (default: "3306")
  - Port for the  Zabbix database server.
* `[:zabbix][:database][:root_user]`  - 
  - Root user for the Zabbix database server.
* `[:zabbix][:database][:root_password]` - 
  - Root password for the Zabbix database server.
* `[:zabbix][:database][:user]`       -  (default: "zabbix")
  - User for the Zabbix database.
* `[:zabbix][:database][:password]`   - 
  - Password for the Zabbix database user.
* `[:zabbix][:database][:name]`       -  (default: "zabbix")
  - Name of the Zabbix database.
* `[:zabbix][:web][:fqdn]`            - 
  - The FQDN for the web application when using Apache to serve the Zabbix web frontend.
* `[:zabbix][:web][:bind_ip]`         -  (default: "127.0.0.1")
  - The local IP to bind PHP at when using nginx to serve the Zabbix web frontend.
* `[:zabbix][:web][:port]`            -  (default: "9101")
  - The local port to bind PHP at when using nginx to serve the Zabbix web frontend.
* `[:zabbix][:web][:log_dir]`         -  (default: "/var/log/zabbix_web")
  - The directory for the Zabbix web frontend's logs.
* `[:zabbix][:web][:install_method]`  -  (default: "apache")
  - The webserver to use in front of PHP: 'apache' or 'nginx'.
* `[:zabbix][:web][:timezone]`        -  (default: "Europe/London")
  - The timezone to display date information in.
* `[:zabbix][:api][:path]`            -  (default: "api_jsonrpc.php")
  - The path on the Zabbix web frontend from which the Zabbix API is served.
* `[:zabbix][:api][:username]`        - 
  - The Zabbix user for talking to Zabbix's API.
* `[:zabbix][:api][:password]`        - 
  - The Zabbix user's password for talking to Zabbix's API.
* `[:zabbix][:smtp][:from]`           -  (default: "fixme@example.com")
  - The From: address used by Zabbix to send email.
* `[:zabbix][:smtp][:server]`         -  (default: "smtp.example.com")
  - The SMTP server used by Zabbix to send email.
* `[:zabbix][:smtp][:port]`           -  (default: "25")
  - The SMTP server's port used by Zabbix to send email.
* `[:zabbix][:smtp][:username]`       -  (default: "zabbix")
  - The username used by Zabbix to send email.
* `[:zabbix][:smtp][:password]`       -  (default: "fixme")
  - The password used by Zabbix to send email.
* `[:zabbix][:twilio][:id]`           -  (default: "fixme")
  - The Twilio ID used by Zabbix to send SMS.
* `[:zabbix][:twilio][:token]`        -  (default: "fixme")
  - The Twilio token used by Zabbix to send SMS.
* `[:zabbix][:twilio][:phone]`        -  (default: "fixme")
  - The Twilio phone number used by Zabbix to send SMS.
* `[:users][:zabbix][:uid]`           -  (default: "447")
* `[:groups][:zabbix][:gid]`          -  (default: "447")

## License and Author

Author::                Dhruv Bansal (<dhruv@infochimps.com>)
Copyright::             2011, Dhruv Bansal

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
