

# set to nil to pull name from actual machine's distro, or
# set an explicit value (e.g. 'maverick')
# note however that cloudera is very conservative to update its distro support
default[:apt][:cloudera][:force_distro] = nil # 'maverick'

