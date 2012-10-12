#
# Cookbook Name:: strongswan
# Attributes:: default

# set our config dir so it may be changed if the need ever does arise
set[:strongswan][:server][:conf_dir] = '/etc'
set[:strongswan][:client][:conf_dir] = '/etc/ipsec.d/clients'

# enable ipsec and xl2tpd services so that we can start, stop and reload them
default[:strongswan][:server][:service_name][:ipsec] = 'ipsec'
default[:strongswan][:server][:service_name][:l2tp] = 'xl2tpd'

# [config] section for server-side file '/etc/ipsec.conf'
default[:strongswan][:server][:tunable][:ipsec][:conf][:keyexchange] = 'ikev1'
default[:strongswan][:server][:tunable][:ipsec][:conf][:ike] = '3des-sha256-modp1536'
default[:strongswan][:server][:tunable][:ipsec][:conf][:esp] = '3des-sha256'

# [conn] section for file '/etc/ipsec.conf'
# left is the local side from the view of this machine
[ default[:strongswan][:server][:tunable][:ipsec][:left] ].each do |section|
	section[:firewall] = 'yes'
	section[:id] = '@moon.strongswan.org'
	section[:left] = '%defaultroute'
	section[:leftauth] = 'psk'
	section[:sourceip] = '10.107.9.0/24'
	section[:subnet] = '10.107.9.0/24'
end

[ default[:strongswan][:client][:tunable][:ipsec][:left] ].each do |section|
	section[:firewall] = 'yes'
	section[:id] = 'client@strongswan.org'
	section[:left] = '%defaultroute'
	section[:leftauth] = 'psk'
	section[:sourceip] = '%config'
	section[:subnet] = '10.107.0.0/24'
end

# right is the remote side from the view of this machine
[ default[:strongswan][:server][:tunable][:ipsec][:right] ].each do |section|
	section[:firewall] = 'yes'
	section[:id] = 'client@strongswan.org'
	section[:right] = '%defaultroute'
	section[:rightauth] = 'psk'
	section[:rightauth2] = 'xauth'
	section[:sourceip] = '%config'
	section[:subnet] = '10.107.9.0/24'
end

[ default[:strongswan][:client][:tunable][:ipsec][:right] ].each do |section|
	section[:firewall] = 'no'
	section[:id] = '@moon.strongswan.org'
	section[:right] = '%defaultroute'
	section[:rightauth] = 'psk'
	section[:sourceip] = '10.107.9.0/24'
	section[:subnet] = '10.107.9.0/24'
end

# Ensure NAT-transversal is enabled in '/etc/ipsec.conf' 
default[:strongswan][:server][:tunable][:ipsec][:conf][:natt] = "yes"

# attributes needed for '/etc/ipsec.secrets'
default[:strongswan][:server][:tunable][:ipsec][:psk] = 'wehavenobananastoday'

# needed for '/etc/strongswan.conf'
# default[:strongswan][:server][:tunable][:ipsec][:]

# attributes needed for '/etc/xl2tpd/xl2tpd.conf'
default[:strongswan][:server][:tunable][:l2tp][:ip_min] = '10.107.0.51'
default[:strongswan][:server][:tunable][:l2tp][:ip_max] = '10.107.0.100'

# attributes needed for '/etc/ppp/options.xl2tpd'
# default[:strongswan][:server][:tunable][:l2tp][:]

# attributes needed for /etc/ppp/chap-secrets'
default[:strongswan][:server][:tunable][:l2tp][:chapsecret] = 'changeme'

# tunables we have disabled but are not yet prepared to completely remove
# default[:strongswan][:server][:tunable][:ipsec][:left][:cert] = 'infochimpsKey.pem'
# default[:strongswan][:server][:tunable][:ipsec][:left][:ip] = '107.23.79.201'
