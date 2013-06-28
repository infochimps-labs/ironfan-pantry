maintainer        "Infochimps"
maintainer_email  "coders@infochimps.com"
description       "Creates and attaches volume from an ebs snapshot"
version           IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

recipe "ebs_migrate::default",        "Default recipe.  This is a place holder"
recipe "ebs_migrate::migrate",        "This recipe uses Fog to take care of the volume management"
recipe "ebs_migrate::elasticsearch",  "Takes care of stopping elasticsearch service and restarting it"
