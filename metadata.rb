maintainer       "Dhruv Bansal"
maintainer_email "dhruv@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.19"

description      "Installs/Configures Zabbix server, client, & web frontend."

depends          "apache2"
depends          "nginx"
depends          "database", ">= 1.0.0"
depends          "mysql", ">= 1.2.0"
depends          "ufw", ">= 0.6.1"
depends          "metachef"

recipe           "zabbix::default",                    "Sets up Zabbix directory structure & user."
recipe           "zabbix::agent_prebuild",             "Downloads, configures, & launches pre-built Zabbix agent"
recipe           "zabbix::agent_source",               "Downloads, builds, configures, & launches Zabbix agent from source."
recipe           "zabbix::agent",                      "Installs and launches Zabbix agent."
recipe           "zabbix::firewall",                   "Configures firewall access between Zabbix server & agents."
recipe           "zabbix::database_mysql",             "Configures Zabbix MySQL database."
recipe           "zabbix::database",                   "Configures Zabbix database."
recipe           "zabbix::server",                     "Installs and launches Zabbix server."
recipe           "zabbix::server_source",              "Downloads, builds, configures, & launches Zabbix server from source."
recipe           "zabbix::server_sends_texts",         "Configures Zabbix server to be able to send texts using Twilio."
recipe           "zabbix::server_sends_email",         "Configures Zabbix server to be able to send email via a remote SMTP server."
recipe           "zabbix::web",                        "Configures PHP-driven, reverse-proxied Zabbix web frontend."
recipe           "zabbix::web_apache",                 "Configures PHP-driven, reverse-proxied Zabbix web frontend using Apache."
recipe           "zabbix::web_nginx",                  "Configures PHP-driven, reverse-proxied Zabbix web frontend using nginx."
recipe           "zabbix::create_hosts",               "Create Hosts"

%w[ debian ubuntu ].each do |os|
  supports os
end

attribute "zabbix/home_dir",
  :display_name          => "",
  :description           => "The base installation directory for Zabbix.",
  :default               => "/opt/zabbix"

attribute "zabbix/host_groups",
  :display_name          => "",
  :description           => "Host groups for this node in Zabbix.",
  :default               => ""

attribute "zabbix/templates",
  :display_name          => "",
  :description           => "Templates for this node in Zabbix.",
  :default               => ""

attribute "zabbix/user",
  :display_name          => "",
  :description           => "",
  :default               => "zabbix"

attribute "zabbix/agent/servers",
  :display_name          => "",
  :description           => "Hostnames/IPs of servers the Zabbix agent will accept connections from.",
  :default               => ""

attribute "zabbix/agent/configure_options",
  :display_name          => "",
  :description           => "Options passed to ./configure script when building agent.",
  :type                  => "array",
  :default               => ["--prefix=/opt/zabbix", "--with-libcurl"]

attribute "zabbix/agent/branch",
  :display_name          => "",
  :description           => "Name of the Zabbix branch to use.",
  :default               => "ZABBIX%20Latest%20Stable"

attribute "zabbix/agent/version",
  :display_name          => "",
  :description           => "Version of the Zabbix agent to install.",
  :default               => "1.8.5"

attribute "zabbix/agent/install_method",
  :display_name          => "",
  :description           => "How to install the Zabbix agent: 'prebuild' or 'source'.",
  :default               => "prebuild"

attribute "zabbix/agent/log_dir",
  :display_name          => "",
  :description           => "The log directory for the Zabbix agent.",
  :default               => "/var/log/zabbix_agent"

attribute "zabbix/agent/create_host",
  :display_name          => "",
  :description           => "Whether to create a Zabbix host for this node.",
  :default               => "true"

attribute "zabbix/server/version",
  :display_name          => "",
  :description           => "The version of the Zabbix server to install.",
  :default               => "1.8.8"

attribute "zabbix/server/branch",
  :display_name          => "",
  :description           => "Name of the Zabbix branch to use.",
  :default               => "ZABBIX%20Latest%20Stable"

attribute "zabbix/server/install_method",
  :display_name          => "",
  :description           => "How to install the zabbix server: source.",
  :default               => "source"

attribute "zabbix/server/configure_options",
  :display_name          => "",
  :description           => "Options passed to the ./configure script when building the Zabbix server.",
  :type                  => "array",
  :default               => ["--prefix=/opt/zabbix", "--with-libcurl", "--with-net-snmp", "--with-mysql "]

attribute "zabbix/server/log_dir",
  :display_name          => "",
  :description           => "The log directory for the Zabbix server.",
  :default               => "/var/log/zabbix_server"

attribute "zabbix/database/install_method",
  :display_name          => "",
  :description           => "Method of installing the database: only 'mysql'.",
  :default               => "mysql"

attribute "zabbix/database/host",
  :display_name          => "",
  :description           => "Host for the Zabbix database server.",
  :default               => "localhost"

attribute "zabbix/database/port",
  :display_name          => "",
  :description           => "Port for the  Zabbix database server.",
  :default               => "3306"

attribute "zabbix/database/root_user",
  :display_name          => "",
  :description           => "Root user for the Zabbix database server.",
  :default               => ""

attribute "zabbix/database/root_password",
  :display_name          => "",
  :description           => "Root password for the Zabbix database server.",
  :default               => ""

attribute "zabbix/database/user",
  :display_name          => "",
  :description           => "User for the Zabbix database.",
  :default               => "zabbix"

attribute "zabbix/database/password",
  :display_name          => "",
  :description           => "Password for the Zabbix database user.",
  :default               => ""

attribute "zabbix/database/name",
  :display_name          => "",
  :description           => "Name of the Zabbix database.",
  :default               => "zabbix"

attribute "zabbix/web/fqdn",
  :display_name          => "",
  :description           => "The FQDN for the web application when using Apache to serve the Zabbix web frontend.",
  :default               => ""

attribute "zabbix/web/bind_ip",
  :display_name          => "",
  :description           => "The local IP to bind PHP at when using nginx to serve the Zabbix web frontend.",
  :default               => "127.0.0.1"

attribute "zabbix/web/port",
  :display_name          => "",
  :description           => "The local port to bind PHP at when using nginx to serve the Zabbix web frontend.",
  :default               => "9101"

attribute "zabbix/web/log_dir",
  :display_name          => "",
  :description           => "The directory for the Zabbix web frontend's logs.",
  :default               => "/var/log/zabbix_web"

attribute "zabbix/web/install_method",
  :display_name          => "",
  :description           => "The webserver to use in front of PHP: 'apache' or 'nginx'.",
  :default               => "apache"

attribute "zabbix/web/timezone",
  :display_name          => "",
  :description           => "The timezone to display date information in.",
  :default               => "Europe/London"

attribute "zabbix/api/path",
  :display_name          => "",
  :description           => "The path on the Zabbix web frontend from which the Zabbix API is served.",
  :default               => "api_jsonrpc.php"

attribute "zabbix/api/username",
  :display_name          => "",
  :description           => "The Zabbix user for talking to Zabbix's API.",
  :default               => ""

attribute "zabbix/api/password",
  :display_name          => "",
  :description           => "The Zabbix user's password for talking to Zabbix's API.",
  :default               => ""

attribute "zabbix/smtp/from",
  :display_name          => "",
  :description           => "The From: address used by Zabbix to send email.",
  :default               => "fixme@example.com"

attribute "zabbix/smtp/server",
  :display_name          => "",
  :description           => "The SMTP server used by Zabbix to send email.",
  :default               => "smtp.example.com"

attribute "zabbix/smtp/port",
  :display_name          => "",
  :description           => "The SMTP server's port used by Zabbix to send email.",
  :default               => "25"

attribute "zabbix/smtp/username",
  :display_name          => "",
  :description           => "The username used by Zabbix to send email.",
  :default               => "zabbix"

attribute "zabbix/smtp/password",
  :display_name          => "",
  :description           => "The password used by Zabbix to send email.",
  :default               => "fixme"

attribute "zabbix/twilio/id",
  :display_name          => "",
  :description           => "The Twilio ID used by Zabbix to send SMS.",
  :default               => "fixme"

attribute "zabbix/twilio/token",
  :display_name          => "",
  :description           => "The Twilio token used by Zabbix to send SMS.",
  :default               => "fixme"

attribute "zabbix/twilio/phone",
  :display_name          => "",
  :description           => "The Twilio phone number used by Zabbix to send SMS.",
  :default               => "fixme"

attribute "users/zabbix/uid",
  :display_name          => "",
  :description           => "",
  :default               => "447"

attribute "groups/zabbix/gid",
  :display_name          => "",
  :description           => "",
  :default               => "447"
