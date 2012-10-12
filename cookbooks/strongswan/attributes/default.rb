#
# Cookbook Name:: strongswan
# Attributes:: default

=begin

First, a moment to explain how things are laid and the reasoning for same. 
There are 
default[:strongswan][:server] = {}

default[:strongswan][:server][:tunable] = {}

default[:strongswan][:client] = {}

default[:strongswan][:client][:tunable] = {}
	
	
=end

# enable ipsec and xl2tpd services so that we can start, stop and reload them
default[:strongswan][:server][:service_name][:ipsec] = 'ipsec'
default[:strongswan][:server][:service_name][:l2tp] = 'xl2tpd'
# set our config dir so it may be changed if the need ever does arise
set[:strongswan][:server][:conf_dir] = '/etc'
set[:strongswan][:client][:conf_dir] = '/etc/ipsec.d/clients'

# [config] section for file '/etc/ipsec.conf'
default[:strongswan][:server][:tunable][:ipsec][:keyexchange] = 'ikev1'
default[:strongswan][:server][:tunable][:ipsec][:ike] = '3des-sha256-modp1536'
default[:strongswan][:server][:tunable][:ipsec][:esp] = '3des-sha256'

# [conn] section for file '/etc/ipsec.conf'
# left is the local side from the view of this machine
default[:strongswan][:server][:tunable][:ipsec][:left][:firewall] = 'yes'
default[:strongswan][:server][:tunable][:ipsec][:left][:id] = '@us-east-1-vpc.chimpy.us'
default[:strongswan][:server][:tunable][:ipsec][:left][:left] = '%defaultroute'
default[:strongswan][:server][:tunable][:ipsec][:left][:leftauth] = 'psk'
default[:strongswan][:server][:tunable][:ipsec][:left][:subnet] = '10.107.9.0/16'

default[:strongswan][:client][:tunable][:ipsec][:conf][:ike] = '3des-sha256-modp1536'
default[:strongswan][:client][:tunable][:ipsec][:conf][:esp] = '3des-sha256'
default[:strongswan][:client][:tunable][:ipsec][:left][:firewall] = 'yes'
default[:strongswan][:client][:tunable][:ipsec][:left][:id] = '@us-east-1-vpc.chimpy.us'
default[:strongswan][:client][:tunable][:ipsec][:left][:left] = '%defaultroute'
default[:strongswan][:client][:tunable][:ipsec][:left][:leftauth] = 'psk'
default[:strongswan][:client][:tunable][:ipsec][:left][:subnet] = '10.107.9.0/24'

# right is the remote side from the view of this machine
default[:strongswan][:server][:tunable][:ipsec][:right][:firewall] = 'no'
default[:strongswan][:server][:tunable][:ipsec][:right][:right] = '%any'
default[:strongswan][:server][:tunable][:ipsec][:right][:rightauth] = 'psk'
default[:strongswan][:server][:tunable][:ipsec][:right][:rightauth2] = 'xauth'
default[:strongswan][:server][:tunable][:ipsec][:right][:sourceip] = '10.107.9.0/24'
default[:strongswan][:server][:tunable][:ipsec][:right][:subnet] = '10.107.0.0/24'

=begin
We change the default NAT-transversal in '/etc/ipsec.conf' to 'yes' to allow
generic clients to connect to the strongswan server. If you have noone using 
Windows or OS X clients and no connections from iPhone's, you may turn this 
setting off again.
=end
default[:strongswan][:server][:tunable][:ipsec][:natt] = "yes"

# attributes needed for '/etc/ipsec.secrets'
default[:strongswan][:server][:tunable][:ipsec][:psk] = 'wehavenobananastoday'

# needed for '/etc/strongswan.conf'
# default[:strongswan][:server][:tunable][:ipsec][:]

# attributes needed for '/etc/xl2tpd/xl2tpd.conf'
default[:strongswan][:server][:tunable][:l2tp][:ip_min] = '10.107.9.51'
default[:strongswan][:server][:tunable][:l2tp][:ip_max] = '10.107.9.100'

# attributes needed for '/etc/ppp/options.xl2tpd'
# default[:strongswan][:server][:tunable][:l2tp][:]

# attributes needed for /etc/ppp/chap-secrets'
default[:strongswan][:server][:tunable][:l2tp][:chapsecret] = 'changeme'

# tunables we have disabled but are not yet prepared to completely remove
# default[:strongswan][:server][:tunable][:ipsec][:left][:cert] = 'infochimpsKey.pem'
# default[:strongswan][:server][:tunable][:ipsec][:left][:ip] = '107.23.79.201'
