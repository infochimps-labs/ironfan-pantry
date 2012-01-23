maintainer       "Platform14.com."
maintainer_email "jamesc.000@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures route53"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe "route53", "Installs the route53 RubyGem"
recipe "route53::ec2", "Dynamically configures Route53 resource records for EC2 nodes based on instance ID and prepopulated attributes on the node"
#recipe "route53::a_record", "Example resource usage to configure an A record"

attribute "route53/zone",
  :display_name => "Route53 zone name to create/modify records in",
  :description => "The route53 zone, which should already exist.  No default."

attribute "route53/ec2",
  :display_name => "EC2 configuration parameters",
  :description => "EC2 configuration parameters.  No default." ,
  :type => "hash"

attribute "route53/ec2/type",
  :display_name => "EC2 configuration parameters",
  :description => "Node Type - used to construct hostname.  No default."

attribute "route53/ec2/env",
  :display_name => "EC2 configuration parameters",
  :description => "Environment (similar to node[:app_environment]).  No default."