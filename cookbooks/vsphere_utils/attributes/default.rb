default[:vsphere_utils][:domain] = nil

#
# Automatically update DNS... prettty primitive right now
#

default[:vsphere_utils][:dns][:master      ] = nil
default[:vsphere_utils][:dns][:keyname     ] = nil
default[:vsphere_utils][:dns][:secret      ] = nil
default[:vsphere_utils][:dns][:ttl         ] = 86400 
default[:vsphere_utils][:dns][:nameservers ] = ["208.67.222.222", "208.67.220.220"]
default[:vsphere_utils][:dns][:domain      ] = nil
default[:vsphere_utils][:dns][:search      ] = nil
