#
# User
#
default[:rundeck][:user]     = 'rundeck'
default[:rundeck][:group]    = 'rundeck'
default[:users]['rundeck'][:uid]  = 444
default[:groups]['rundeck'][:gid] = 444

default[:rundeck][:server][:username] = 'admin'
default[:rundeck][:server][:password] = 'admin'

default[:rundeck][:users]        = { :admin => { :password => 'admin' }}
default[:rundeck][:active_users] = ['admin']

default[:rundeck][:chef_rundeck][:username] = 'rundeck'

#
# Server
#
default[:rundeck][:pid_dir]  = '/var/run/rundeck'
default[:rundeck][:home_dir] = '/var/lib/rundeck'
default[:rundeck][:conf_dir] = '/etc/rundeck'
default[:rundeck][:log_dir]  = '/var/log/rundeck'
default[:rundeck][:data_dir] = '/usr/local/share/rundeck' # rundeck's "projects" go in here

default[:rundeck][:server][:port] = 4440

#
# Chef Rundeck
#

default[:rundeck][:chef_rundeck][:git_url]  = 'https://github.com/infochimps-labs/chef-rundeck.git'
default[:rundeck][:chef_rundeck][:home_dir] = '/usr/local/share/chef-rundeck'
default[:rundeck][:chef_rundeck][:log_dir]  = '/var/log/chef-rundeck'
default[:rundeck][:chef_rundeck][:conf_dir] = '/etc/chef'

default[:rundeck][:chef_rundeck][:port] = 9980

#
# Web frontend
# 

default[:rundeck][:web][:log_dir] = '/var/log/rundeck_web'

#
# SSL
#
default[:rundeck][:use_ssl]             = false
default[:rundeck][:ssl][:port]          = 4443
default[:rundeck][:ssl][:password]      = 'adminadmin'
default[:rundeck][:ssl][:org_unit]      = 'org_unit'
default[:rundeck][:ssl][:org]           = 'example.org'

#
# Email
#
default[:rundeck][:email][:to]            = 'root@localhost'
default[:rundeck][:email][:from]          = 'Rundeck'
default[:rundeck][:email][:do_not_reply]  = 'do-not-reply'
default[:rundeck][:email][:host]          = 'localhost'
default[:rundeck][:email][:port]          = 25
default[:rundeck][:email][:username]      = 'rundeck@localhost'
default[:rundeck][:email][:password]      = 'changeme'
default[:rundeck][:email][:ssl]           = false
default[:rundeck][:email][:fail_on_error] = true

#
# Install
#
# default[:rundeck][:version]     = '1.4.4-1'
# default[:rundeck][:release_url] = 'http://build.rundeck.org/job/rundeck-master/lasxtStableBuild/artifact/packaging/rundeck-:version:.deb'
default[:rundeck][:version]     = '1.5.3-1-GA'
default[:rundeck][:release_url] = 'http://download.rundeck.org/deb/rundeck-:version:.deb'
