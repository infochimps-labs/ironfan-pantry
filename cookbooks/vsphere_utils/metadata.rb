maintainer       "Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
description      "vSphere utility functions"
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

depends          "silverware"

recipe           "vsphere_utils::default",          "Default"
recipe           "vsphere_utils::hostname",         "Sets hostname to node name"
recipe           "vsphere_utils::vsphere_metadata", "Populates vSphere metadata"
recipe           "vsphere_utils::dns",              "Manages DNS and resolv.conf"
