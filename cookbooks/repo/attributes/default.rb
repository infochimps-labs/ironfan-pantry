default[:repo][:root]      = "/var/packages"
default[:repo][:type]      = [ "apt" ]

#
# Keys
#

default[:repo][:keys][:cloudera   ] = "327574EE02A818DD"
default[:repo][:keys][:webupd8team] = "C2518248EEA14886"

#
# Apt
#
default[:repo][:apt][:base    ] = "#{default[:repo][:root]}/apt"
default[:repo][:apt][:signwith] = nil

default[:repo][:apt][:minute  ] = 0
default[:repo][:apt][:hour    ] = 7
default[:repo][:apt][:day     ] = '*' 
default[:repo][:apt][:month   ] = '*'
default[:repo][:apt][:weekday ] = '*'

#
# Yum
#
default[:repo][:yum][:base   ] = "#{default[:repo][:root]}/yum"

default[:repo][:yum][:minute ] = 0
default[:repo][:yum][:hour   ] = 7
default[:repo][:yum][:day    ] = '*'
default[:repo][:yum][:month  ] = '*'
default[:repo][:yum][:weekday] = '*'

#
# Gem
#
default[:repo][:gem][:base] = "#{default[:repo][:root]}/gem"

