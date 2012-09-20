graphite_prefix_dir= '/usr/local' # changed from graphite's default of /opt

default[:graphite][:prefix_dir]                       = '/usr/local/share'
default[:graphite][:home_dir]                         = '/usr/local/share/graphite'
default[:graphite][:conf_dir]                         = '/etc/graphite'
default[:graphite][:pid_dir]                          = '/var/run/graphite'
default[:graphite][:carbon   ][:log_dir]              = '/var/log/graphite/carbon'
default[:graphite][:dashboard][:log_dir]              = '/var/log/graphite/dashboard'

default[:graphite][:user]                             = 'www-data'
default[:graphite][:carbon   ][:user]                 = 'www-data'
default[:graphite][:dashboard][:user]                 = 'www-data'

default[:users ]['graphite'][:uid]                    = 446
default[:groups]['graphite'][:gid]                    = 446

default[:graphite][:carbon   ][:run_state]            = :start

default[:graphite][:carbon   ][:line_rcvr_addr]       = "0.0.0.0"
default[:graphite][:carbon   ][:pickle_rcvr_addr]     = "0.0.0.0"
default[:graphite][:carbon   ][:cache_query_addr]     = "0.0.0.0"
default[:graphite][:carbon   ][:line_rcvr_port]       = "2003"
default[:graphite][:carbon   ][:pickle_rcvr_port]     = "2004"
default[:graphite][:carbon   ][:cache_query_port]     = "7002"

default[:graphite][:carbon   ][:version]              = "0.9.10"
default[:graphite][:carbon   ][:release_url]          = "https://launchpadlibrarian.net/106575865/carbon-0.9.10.tar.gz"
default[:graphite][:carbon   ][:release_url_checksum] = "053b2df1c928250f59518e9bb9f35ad5"

default[:graphite][:whisper  ][:version]              = "0.9.10"
default[:graphite][:whisper  ][:release_url]          = "https://launchpadlibrarian.net/106575859/whisper-0.9.10.tar.gz"
default[:graphite][:whisper  ][:release_url_checksum] = "cf7d7d73e115f50e682f46c4eb52be09"


default[:graphite][:dashboard][:version]              = "0.9.10"
default[:graphite][:dashboard][:release_url]          = "https://launchpadlibrarian.net/106575888/graphite-web-0.9.10.tar.gz"
default[:graphite][:dashboard][:release_url_checksum] = "f54bf784139c7aef441f5cc1bc66dab4"
