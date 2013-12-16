#
# Core Integration Code
#
default[:jenkins_integration][:git][:name]      = 'Jenkins Integration'
default[:jenkins_integration][:git][:email]     = 'jenkins@example.org'

default[:jenkins_integration][:security]        = 'local_users'
default[:jenkins_integration][:deploy_key]      = nil           # Set this in cluster

# FIXME: Adding a plugin here seems to only work on a first-converge (new node), not subsequent converges
node.default[:jenkins][:server][:plugins] += %w[ parameterized-trigger ansicolor build-token-root radiatorviewplugin text-finder-run-condition parameterized-trigger run-condition conditional-buildstep ]

# Allow dashboard to be visibile (read-only) to non-authenticated users
default[:jenkins_integration][:addl_permissions] = %w[hudson.model.Hudson.Read:anonymous hudson.model.Item.Read:anonymous hudson.model.View.Read:anonymous]

# FIXME: some tests are in enterprise cookbook
radiator = <<eos
    <hudson.model.RadiatorView plugin="radiatorviewplugin@1.13">
      <owner class="hudson" reference="../../.."/>
      <name>Converge</name>
      <filterExecutors>false</filterExecutors>
      <filterQueue>false</filterQueue>
      <properties class="hudson.model.View$PropertyList"/>
      <jobNames>
        <comparator class="hudson.util.CaseInsensitiveComparator"/>
        <string>Converge_and_ironcuke_existing_host</string>
        <string>Test_that_the_SRP_converges_from_the_RC_branch</string>
      </jobNames>
      <jobFilters/>
      <columns/>
      <recurse>true</recurse>
      <showStable>false</showStable>
      <showStableDetail>false</showStableDetail>
      <highVis>true</highVis>
      <groupByPrefix>false</groupByPrefix>
    </hudson.model.RadiatorView>
eos

default[:jenkins_integration][:addl_views] = [ radiator ]

# 
# Cookbook CI
# 
default[:jenkins_integration][:cookbook_ci][:test_homebase] = 'git@github.com:infochimps-labs/ironfan-homebase.git'
default[:jenkins_integration][:cookbook_ci][:chef_user]  = 'test'
default[:jenkins_integration][:cookbook_ci][:targets][:primary]    = [ 'testharness-simple' ]
default[:jenkins_integration][:cookbook_ci][:targets][:secondary]    = [ 'testharness-simple' ]
default[:jenkins_integration][:cookbook_ci][:broken]     = nil   # Set to launch a known-broken facet
default[:jenkins_integration][:cookbook_ci][:branch]     = 'master'
default[:jenkins_integration][:cookbook_ci][:schedule]   = '0 */4 * * *'
default[:jenkins_integration][:cookbook_ci][:cuke_schedule]   = '*/20 * * * *'
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
default[:jenkins_integration][:strainer][:facets]         = {} # Hash where key is facet and value is a list of cookbooks
                                                               # :el_ridiculoso-zk => [ 'zookeeper' ],
                                                               # :el_ridiculoso-es => [ 'elasticsearch' ] 
                                                              

#
# SMTP
# 
default[:jenkins_integration][:smtp][:from]     = 'Mr. Jenkins <jenkins@example.com>'
default[:jenkins_integration][:smtp][:server]   = 'smtp.example.com'
default[:jenkins_integration][:smtp][:port]     = '25'
default[:jenkins_integration][:smtp][:username] = ''
default[:jenkins_integration][:smtp][:password] = ''


