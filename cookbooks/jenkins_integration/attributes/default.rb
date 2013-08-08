#
# Core Integration Code
#
default[:jenkins_integration][:git][:name]      = 'Jenkins Integration'
default[:jenkins_integration][:git][:email]     = 'jenkins@example.org'

default[:jenkins_integration][:security]        = 'local_users'
default[:jenkins_integration][:deploy_key]      = nil           # Set this in cluster

node.default[:jenkins][:server][:plugins] += %w[ parameterized-trigger ansicolor build-token-root ]

# 
# Cookbook CI
# 
default[:jenkins_integration][:cookbook_ci][:test_homebase] = 'git@github.com:infochimps-labs/ironfan-homebase.git'
default[:jenkins_integration][:cookbook_ci][:chef_user]  = 'test'
default[:jenkins_integration][:cookbook_ci][:targets]    = [ 'testharness-simple' ]
default[:jenkins_integration][:cookbook_ci][:broken]     = nil   # Set to launch a known-broken facet
default[:jenkins_integration][:cookbook_ci][:branch]     = 'master'
default[:jenkins_integration][:cookbook_ci][:schedule]   = '@midnight'
default[:jenkins_integration][:cookbook_ci][:max_wait]   = 60*20 # 20 minutes

koans = Mash.new()
koans[:testing] = "Newest divergences ready to converge."
koans[:staging] = "Everything has converged once more. Strut and fret your hour upon this new stage."
default[:jenkins_integration][:cookbook_ci][:koan] = koans

pantries        = %w[ git@github.com:infochimps-labs/ironfan-pantry.git ]
homebases       = %w[ git@github.com:infochimps-labs/ironfan-homebase.git ]
default[:jenkins_integration][:cookbook_ci][:pantries]   = pantries
default[:jenkins_integration][:cookbook_ci][:homebases]  = homebases

#
# Strainer CI
#
default[:jenkins_integration][:strainer][:pantry]         = 'git@github.com:infochimps-labs/ironfan-pantry.git'
default[:jenkins_integration][:strainer][:notification]   = false
default[:jenkins_integration][:strainer][:schedule]       = '*/5 * * * *'
default[:jenkins_integration][:strainer][:test_homebase]  = 'https://github.com/infochimps-labs/ironfan-homebase.git'
default[:jenkins_integration][:strainer][:token]          = 'changeme'
default[:jenkins_integration][:strainer][:cluster]        = nil
default[:jenkins_integration][:strainer][:facets]         = { # This is broken because gorillib wont let this be overridden
                                                              :zk => [ 'zookeeper' ],
                                                              :es => [ 'elasticsearch' ] 
                                                            } # Define cluster and make your testing facets
                                                              

#
# SMTP
# 
default[:jenkins_integration][:smtp][:from]     = 'Mr. Jenkins <jenkins@example.com>'
default[:jenkins_integration][:smtp][:server]   = 'smtp.example.com'
default[:jenkins_integration][:smtp][:port]     = '25'
default[:jenkins_integration][:smtp][:username] = ''
default[:jenkins_integration][:smtp][:password] = ''


