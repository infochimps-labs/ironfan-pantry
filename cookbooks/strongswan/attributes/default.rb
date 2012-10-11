#
# Cookbook Name:: strongswan
# Attributes:: default

# some baseline settings-fu for ipsec itself
default['strongswan']['ipsec']['listen_ip'] = attribute?('cloud') ? cloud['local_ipv4'] : ipaddress
default['strongswan']['ipsec']['service_name']            = "ipsec"
# set our config dir so it may be changed if the need ever does arise
set['strongswan']['ipsec']['conf_dir']                    = '/etc'

# [config] section for file '/etc/ipsec.conf'
default['strongswan']['ipsec']['tunable']['ike_version'] = 'ikev2'   

# [conn] section for file '/etc/ipsec.conf'

# left is the local side from the view of this machine
# default['strongswan']['ipsec']['tunable']['left']['cert'] = 'infochimpsKey.pem'
default['strongswan']['ipsec']['tunable']['left']['firewall'] = 'yes'
default['strongswan']['ipsec']['tunable']['left']['left'] = '%defaultroute'
default['strongswan']['ipsec']['tunable']['left']['id'] = '@us-east-1-vpc.chimpy.us'
default['strongswan']['ipsec']['tunable']['left']['ip'] = '107.23.79.201'
default['strongswan']['ipsec']['tunable']['left']['subnet'] = '10.107.9.0/24'

# right is the remote side from the view of this machine
default['strongswan']['ipsec']['tunable']['right']['firewall'] = 'no'
default['strongswan']['ipsec']['tunable']['right']['id'] = 'jerry.w.jackson@gmail.com'
default['strongswan']['ipsec']['tunable']['right']['right'] = '%any'
default['strongswan']['ipsec']['tunable']['right']['sourceip'] = '10.107.9.167'
default['strongswan']['ipsec']['tunable']['right']['subnet'] = '10.107.0.0/24'

=begin
We change the default NAT-transversal in '/etc/ipsec.conf' to 'yes' to allow
generic clients to connect to the strongswan server. If you have noone using 
Windows or OS X clients and no connections from iPhone's, you may turn this 
setting off again.
=end
default['strongswan']['ipsec']['tunable']['natt']           = "yes"

# attributes needed for '/etc/ipsec.secrets'
default['strongswan']['ipsec']['tunable']['psk'] = 'wehavenobananastoday'

# needed for '/etc/strongswan.conf'
# default['strongswan']['ipsec']['tunable']['']

default['strongswan']['l2tp']['service_name']            = "xl2tpd"

# attributes needed for '/etc/xl2tpd/xl2tpd.conf'
default['strongswan']['l2tp']['tunable']['ip_min'] = '10.107.9.51'
default['strongswan']['l2tp']['tunable']['ip_max'] = '10.107.9.100'

# attributes needed for '/etc/ppp/options.xl2tpd'
# default['strongswan']['l2tp']['tunable']['']

# attributes needed for /etc/ppp/chap-secrets'
default['strongswan']['l2tp']['tunable']['chapsecret'] = 'changeme'
