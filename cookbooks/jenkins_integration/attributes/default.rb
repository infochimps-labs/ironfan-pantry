default[:jenkins_integration][:git][:name]      = 'Jenkins Integration'
default[:jenkins_integration][:git][:email]     = 'jenkins@example.org'

default[:jenkins_integration][:security]        = 'local_users'

default[:jenkins_integration][:ironfan_ci][:test_homebase] = 'git@github.com:infochimps-labs/ironfan-homebase.git'
default[:jenkins_integration][:ironfan_ci][:chef_user]  = 'test'
default[:jenkins_integration][:ironfan_ci][:target]     = 'testharness-simple'
default[:jenkins_integration][:ironfan_ci][:broken]     = nil   # Set to launch a known-broken facet
default[:jenkins_integration][:ironfan_ci][:branch]     = 'master'
default[:jenkins_integration][:ironfan_ci][:schedule]   = '@midnight'

pantries        = %w[ git@github.com:infochimps-labs/ironfan-pantry.git ]
homebases       = %w[ git@github.com:infochimps-labs/ironfan-homebase.git ]
default[:jenkins_integration][:ironfan_ci][:pantries]   = pantries
default[:jenkins_integration][:ironfan_ci][:homebases]  = homebases

# # Plugins that we need for the Ironfan CI job to work correctly
# node.default[:jenkins][:server][:plugins] += %w[ join parameterized-trigger ]
