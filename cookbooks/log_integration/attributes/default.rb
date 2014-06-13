#
# Logrotate
#

default[:log_integration][:logrotate][:conf_dir]    = '/etc/logrotate.d'
default[:log_integration][:logrotate][:conf_prefix] = nil

# Log rotate has a LOT of options:
#
default[:log_integration][:logrotate][:native_options] = %w[
    compress compresscmd uncompresscmd compressext compressoptions copy
    copytruncate create daily dateext dateformat delaycompress
    extension ifempty include mail mailfirst maillast maxage minsize
    missingok monthly nocompress nocopy nocopytruncate nocreate
    nodelaycompress nodateext nomail nomissingok noolddir
    nosharedscripts noshred notifempty olddir postrotate/endscript
    prerotate/endscript firstaction/endscript lastaction/endscript
    rotate size sharedscripts shred shredcycles start tabooext weekly
    yearly
]

# We take the approach here of listing all options as node attributes.
# We choose a smart set of defaults, fill in those attributes, and
# comment out the other attributes so the node's attributes hash isn't
# stupidly larger with nils.  You can still set one of the commented
# attributes, either on the node level or on the individual log file
# level within an 'announce', and it will still take effect.  
default[:log_integration][:logrotate][:compress]               = true
# default[:log_integration][:logrotate][:compresscmd]            = nil
# default[:log_integration][:logrotate][:uncompresscmd]          = nil
# default[:log_integration][:logrotate][:compressext]            = nil
# default[:log_integration][:logrotate][:compressoptions]        = nil
# default[:log_integration][:logrotate][:copy]                   = nil
default[:log_integration][:logrotate][:copytruncate]           = true
# default[:log_integration][:logrotate][:create]                 = '0600 root root'
default[:log_integration][:logrotate][:daily]                  = true
default[:log_integration][:logrotate][:dateext]                = true
default[:log_integration][:logrotate][:dateformat]             = ".%Y-%m-%d.%s"
default[:log_integration][:logrotate][:delaycompress]          = false
# default[:log_integration][:logrotate][:extension]              = nil
# default[:log_integration][:logrotate][:ifempty]                = nil
# default[:log_integration][:logrotate][:include]                = nil
# default[:log_integration][:logrotate][:mail]                   = nil
# default[:log_integration][:logrotate][:mailfirst]              = nil
# default[:log_integration][:logrotate][:maillast]               = nil
default[:log_integration][:logrotate][:maxage]                 = 2
# default[:log_integration][:logrotate][:minsize]                = nil
default[:log_integration][:logrotate][:missingok]              = true
# default[:log_integration][:logrotate][:monthly]                = nil
# default[:log_integration][:logrotate][:nocompress]             = nil
# default[:log_integration][:logrotate][:nocopy]                 = nil
# default[:log_integration][:logrotate][:nocopytruncate]         = nil
# default[:log_integration][:logrotate][:nocreate]               = nil
# default[:log_integration][:logrotate][:nodelaycompress]        = nil
# default[:log_integration][:logrotate][:nodateext]              = nil
default[:log_integration][:logrotate][:nomail]                 = true
# default[:log_integration][:logrotate][:nomissingok]            = nil
# default[:log_integration][:logrotate][:noolddir]               = nil
# default[:log_integration][:logrotate][:nosharedscripts]        = nil
# default[:log_integration][:logrotate][:noshred]                = nil
default[:log_integration][:logrotate][:notifempty]             = true
default[:log_integration][:logrotate][:olddir]                 = 'rotated'
# default[:log_integration][:logrotate]['postrotate/endscript']  = nil
# default[:log_integration][:logrotate]['prerotate/endscript']   = nil
# default[:log_integration][:logrotate]['firstaction/endscript'] = nil
# default[:log_integration][:logrotate]['lastaction/endscript']  = nil
default[:log_integration][:logrotate][:rotate]                 = 7
default[:log_integration][:logrotate][:size]                   = '50M'
# default[:log_integration][:logrotate][:sharedscripts]          = nil
# default[:log_integration][:logrotate][:shred]                  = nil
# default[:log_integration][:logrotate][:shredcycles]            = nil
default[:log_integration][:logrotate][:start]                  = 1
# default[:log_integration][:logrotate][:tabooext]               = nil
# default[:log_integration][:logrotate][:weekly]                 = nil
# default[:log_integration][:logrotate][:yearly]                 = nil
default[:log_integration][:logrotate][:chef_maxage]            = 7
