default[:jenkins_integration][:git][:name]      = 'Jenkins Integration'
default[:jenkins_integration][:git][:email]     = 'jenkins@example.org'

default[:jenkins_integration][:ironfan_ci][:repository]         = 'git@github.com:infochimps-labs/ironfan-homebase.git'
default[:jenkins_integration][:ironfan_ci][:branches]           = 'master'
default[:jenkins_integration][:ironfan_ci][:chef_user]          = 'testmonkey'
default[:jenkins_integration][:ironfan_ci][:cluster]            = 't9'
default[:jenkins_integration][:ironfan_ci][:facet]              = 'simple'
