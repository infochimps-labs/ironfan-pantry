default[:repo][:root]      = "/var/packages"

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
default[:repo][:gem][:base       ] = "#{default[:repo][:root]}/gem"
default[:repo][:gem][:upstream   ] = "http://rubygems.org"
default[:repo][:gem][:parallelism] = 10 

default[:repo][:gem][:minute ] = 0
default[:repo][:gem][:hour   ] = 7
default[:repo][:gem][:day    ] = '*'
default[:repo][:gem][:month  ] = '*'
default[:repo][:gem][:weekday] = '*'


