#
# Cookbook Name:: strongswan
# Attributes:: default

# set our config dir so it may be changed if the need ever does arise
default[:strongswan][:ipsec][:conf_dir] = '/etc'
default[:strongswan][:l2tp][:conf_dir] = '/etc'
default[:strongswan][:client][:conf_dir] = '/etc/ipsec-clients.d'

# enable ipsec and xl2tpd services so that we can start, stop and reload them
default[:strongswan][:ipsec][:service_name] = 'ipsec'
default[:strongswan][:l2tp][:service_name] = 'xl2tpd'

## for '/etc/ipsec.conf' on server
default[:strongswan][:ipsec][:keyexchange] = 'ikev1'
default[:strongswan][:ipsec][:ike] = '3des-sha256-modp1536'
default[:strongswan][:ipsec][:esp] = '3des-sha256'
# left is the local side from the view of this machine
default[:strongswan][:ipsec][:left][:firewall] = 'yes'
default[:strongswan][:ipsec][:left][:id] = '@moon.strongswan.org'
default[:strongswan][:ipsec][:left][:route] = '%defaultroute'   # aka "left"
default[:strongswan][:ipsec][:left][:auth] = 'psk'
default[:strongswan][:ipsec][:left][:sourceip] = '10.107.9.0/24'
default[:strongswan][:ipsec][:left][:subnet] = '10.107.9.0/24'
# right is the remote side from the view of this machine
default[:strongswan][:ipsec][:right][:firewall] = 'yes'
default[:strongswan][:ipsec][:right][:id] = 'client@strongswan.org'
default[:strongswan][:ipsec][:right][:route] = '%defaultroute'  # aka "right"
default[:strongswan][:ipsec][:right][:auth] = 'psk'
default[:strongswan][:ipsec][:right][:auth2] = 'xauth'
default[:strongswan][:ipsec][:right][:sourceip] = '%config'
default[:strongswan][:ipsec][:right][:subnet] = '10.107.9.0/24'
# Enable NAT-transversal
default[:strongswan][:ipsec][:natt] = "yes"

## pre-shared key for '/etc/ipsec.secrets'
default[:strongswan][:ipsec][:psk] = 'wehavenobananastoday'

## for '/etc/ipsec.conf' on the client
# left is the local side from the view of the client machine
default[:strongswan][:client][:left][:firewall] = 'yes'
default[:strongswan][:client][:left][:id] = 'client@strongswan.org'
default[:strongswan][:client][:left][:route] = '%defaultroute'   # aka "left"
default[:strongswan][:client][:left][:auth] = 'psk'
default[:strongswan][:client][:left][:sourceip] = '%config'
default[:strongswan][:client][:left][:subnet] = '10.107.0.0/24'
# right is the remote side from the view of the client machine
default[:strongswan][:client][:right][:firewall] = 'no'
default[:strongswan][:client][:right][:id] = '@moon.strongswan.org'
default[:strongswan][:client][:right][:route] = '%defaultroute' # aka "right"
default[:strongswan][:client][:right][:auth] = 'psk'
default[:strongswan][:client][:right][:sourceip] = '10.107.9.0/24'
default[:strongswan][:client][:right][:subnet] = '10.107.9.0/24'

## for '/etc/xl2tpd/xl2tpd.conf'
default[:strongswan][:l2tp][:ip_min] = '10.107.0.51'
default[:strongswan][:l2tp][:ip_max] = '10.107.0.100'
# for /etc/ppp/chap-secrets'
default[:strongswan][:l2tp][:chapsecret] = 'changeme'
