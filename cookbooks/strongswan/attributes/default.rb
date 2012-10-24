#
# Cookbook Name:: strongswan
# Attributes:: default

# set our config dir so it may be changed if the need ever does arise
default[:strongswan][:ipsec][:conf_dir]         = '/etc'
default[:strongswan][:l2tp][:conf_dir]          = '/etc'
default[:strongswan][:client][:conf_dir]        = '/etc/ipsec-clients.d'

# enable ipsec and xl2tpd services so that we can start, stop and reload them
default[:strongswan][:ipsec][:service_name]     = 'ipsec'
default[:strongswan][:l2tp][:service_name]      = 'xl2tpd'

## scenario choice - xauth-id-psk-config is the only one currently implemented.
##   visit http://www.strongswan.org/uml-testresults4.html for more options
default[:strongswan][:scenarios]                = ['xauth-id-psk-config']
#default[:strongswan][:scenario]                 = 'xauth-id-psk-config'

# Enable NAT-transversal
default[:strongswan][:ipsec][:natt]             = 'yes'
# Use the older key-exchange protocol, to handle older clients
default[:strongswan][:ipsec][:keyexchange]      = 'ikev1'
# key exchange protocols
default[:strongswan][:ipsec][:ike]              = '3des-sha256-modp1536'
default[:strongswan][:ipsec][:esp]              = '3des-sha256'
# pre-shared key for '/etc/ipsec.secrets'
default[:strongswan][:ipsec][:psk]              = 'wehavenobananastoday'

## Hackity hack, don't talk back
default[:strongswan][:ipsec][:public_ip]        = node[:cloud][:public_ips].first rescue '10.10.0.1'
default[:strongswan][:ipsec][:private_ip]       = node[:cloud][:private_ips].first rescue '192.168.0.1'

# When we refer to local here, we mean relative to the server itself.
#   Inside strongswan configuration, the convention is to call the local
#   machine/network the left side, and the remote the right side. This
#   is relative to the machine on which the configuration resides, which
#   can be somewhat confusing at first.
default[:strongswan][:ipsec][:local][:id]       = 'server@strongswan.org'
# We are protecting the entire VPC, not just this subnet
default[:strongswan][:ipsec][:local][:subnet]   = '10.10.0.0/16'
default[:strongswan][:ipsec][:remote][:id]        = 'client@strongswan.org'
# The virtual IP pool is outside the VPC
default[:strongswan][:ipsec][:remote][:sourceip]  = '10.100.255.0/28'

# ## for '/etc/xl2tpd/xl2tpd.conf'
# default[:strongswan][:l2tp][:ip_min] = '10.107.0.51'
# default[:strongswan][:l2tp][:ip_max] = '10.107.0.100'
# # for /etc/ppp/chap-secrets'
# default[:strongswan][:l2tp][:chapsecret] = 'changeme'
