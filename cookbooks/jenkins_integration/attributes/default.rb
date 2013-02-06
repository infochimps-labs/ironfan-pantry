default[:jenkins_integration][:git][:name]      = 'Jenkins Integration'
default[:jenkins_integration][:git][:email]     = 'jenkins@example.org'

default[:jenkins_integration][:security]        = 'local_users'

default[:jenkins_integration][:ironfan_ci][:repository]         = 'git@github.com:infochimps-labs/ironfan-homebase.git'
default[:jenkins_integration][:ironfan_ci][:chef_user]          = 'test'
default[:jenkins_integration][:ironfan_ci][:target]             = 'testharness-simple'
default[:jenkins_integration][:ironfan_ci][:broken]             = nil   # Set to launch a known-broken instance
default[:jenkins_integration][:ironfan_ci][:branch]             = 'master'

ironfan_pantry = Mash.new
ironfan_pantry[:project]        = 'https://github.com/infochimps-labs/ironfan-pantry/'
ironfan_pantry[:repository]     = 'git@github.com:infochimps-labs/ironfan-pantry.git'
default[:jenkins_integration][:ironfan_ci][:pantries]['ironfan-pantry'] = ironfan_pantry

# Build homebases as above
default[:jenkins_integration][:ironfan_ci][:homebases]          = {}

# Plugins that we need for the Ironfan CI job to work correctly
node.default[:jenkins][:server][:plugins] += %w[ join parameterized-trigger ]
