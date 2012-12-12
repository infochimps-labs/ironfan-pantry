default[:jenkins_integration][:user]    = 'jenkins'
default[:jenkins_integration][:group]   = 'jenkins'

default[:jenkins_integration][:ironfan_homebase][:path]         = '/var/lib/ironfan_homebases'

ironfan_homebase = 'git@github.com:infochimps-labs/ironfan-homebase.git'
default[:jenkins_integration][:ironfan_homebase][:repository]   = ironfan_homebase

default[:jenkins_integration][:ironfan_ci][:path]               = '/var/lib/jenkins/jobs/Ironfan CI'
default[:jenkins_integration][:ironfan_ci][:name]               = 'ironfan_homebase'
default[:jenkins_integration][:ironfan_ci][:repository]         = ironfan_homebase
