
  
https://github.com/acrmp/chefspec


pre-testing -- converge machine 
  https://github.com/acrmp/chefspec

  http://wiki.opscode.com/display/chef/Knife#Knife-test

benchmarks

  bonnie++ 
  hdparm -t
  iozone


in-machine

* x ports on x interfaces open
* daemon is running
* file exists and has string

* log file is accumulating lines at rate X
* script x runs successfully

in-chef

* runlist is X
* chef attribute X should be Y

meta

* chef run was idempotent





__________________________________________________________________________

## Notes from around the web


* ...

  > I'm thinking that the useful thing to test is NOT did chef install
  > some package or setup a user, but rather after chef has run can I
  > interact with the system as I would expect from an external
  > perspective. For example:
  > 
  > * Is the website accessible?
  > * Are unused ports blocked?
  > * When I send an email thorough the website does it end up in my inbox?
  > 
  > Capybara (http://github.com/jnicklas/capybara) enforces this external
  > perspective for webapp testing:
  > 
  > "Access to session, request and response from the test is not
  > possible. Maybe we’ll do response headers at some point in the future,
  > but the others really shouldn’t be touched in an integration test
  > anyway. "
  > 
  > They only let you interact with screen elements that a user could
  > interact with. It makes sense because the things that users interact
  > with are what provides the business value

* Andrew Shafer < andrew@cloudscaling.com>

  > Here's my thinking at this point... which could be wrong on every level.
  > There is really no good way to TDD/BDD configuration management for several
  > reasons:
  > The recipes are already relatively declarative
  > Mocking is useless because it may not reflect 'ground truth'
  > The cycle times to really test convergence are relatively long
  > Trying to test if a package is installed or not is testing the framework,
  > not the recipe IMHO.
  > I agree with the general sentiment that the functional service is the true
  > test.
  > I'm leaning towards 'testing' at that level, ideally with (a superset of?)
  > what should be used for the production monitoring system.
  > So the CI builds services, runs all the checks in test, green can go live
  > and that's that.
  

* Jeremy Deininger < jeremy@rightscale.com>

  > Thought I'd chime in with my experience testing system configuration code @ RightScale so far.  What we've been building are integration style cucumber tests to run a cookbook through it's paces on all platforms and OSs that we support.  
  > First we use our API to spin up 'fresh' server clusters in EC2, one for every platform/OS (variation) that the cookbook will be supporting.  The same could be done using other cloud APIs (anyone else doing this with VMware or etc?)  Starting from scratch is important because of chef's idempotent nature.
  > Then a cucumber test is run against every variation in parallel.  The cucumber test runs a series of recipes on the cluster then uses what we call 'spot checks' to ensure the cluster is configured and functional.  The spot checks are updated when we find a bug, to cover the bug.  An example spot check would be, sshing to every server and checking the mysql.err file for bad strings.
  > These high level integration tests are long running but have been very useful flushing out bugs.
  > ...
  > If you stop by the #rightscale channel on Freenode I'd be happy to embarrass myself by giving you a sneak peak at the features etc..  Would love to bounce ideas around and collaborate if you're interested. jeremydei on Freenode IRC

Ranjib Dey < ranjibd@th...s.com>

  > So far, what we've done for testing is to use rspec for implementing tests.  Here's an example:
  > 
  >    it "should respond on port 80" do
  >      lambda {
  >        TCPSocket.open(@server, 'http')
  >      }.should_not raise_error
  >    end
  > 
  > Before running the tests, I have to manually bootstrap a node using knife. If my instance is the only one in its environment, the spec can find it using knife's search feature.  The bootstrap takes a few minutes, and the 20 or so tests take about half a minute to run.
  > 
  > While I'm iteratively developing a recipe, my work cycle is to edit source, upload a cookbook, and rerun chef-client (usually by rerunning knife boostrap, because the execution environment is different from invoking chef-client directly).  This feels a bit slower than the cycle I'm used to when coding in Ruby because of the upload and bootstrap steps.
  > 
  > I like rspec over other testing tools because of how it generates handy reports, such as this one, which displays an English list of covered test cases:
  > 
  >    $ rspec spec/ -f doc
  > 
  >    Foo role
  >      should respond on port 80
  >      should run memcached
  >      should accept memcached connections
  >      should have mysql account
  >      should allow passwordless sudo to user foo as user bar
  >      should allow passwordless sudo to root as a member of sysadmin
  >      should allow key login as user bar
  >      should mount homedirs on ext4, not NFS
  >      should rotate production.log
  >      should have baz as default vhost
  >      ...
  > 
  > That sample report also gives a feel for sort of things we check.  So far, nearly all of our checks are non-intrusive enough to run on a production system.  (The exception is testing of local email delivery configurations.)
  > 
  > Areas I'd love to see improvement:
  > 
  >    * Shortening the edit-upload-bootstrap-test cycle
  >    * Automating the bootstrap in the context of testing
  >    * Adding rspec primitives for Chef-related testing, which might
  >      include support for multiple platforms
  > 
  > As an example of rspec primitives, instead of:
  > 
  >    it "should respond on port 80" do
  >      lambda {
  >        TCPSocket.open(@server, 'http')
  >      }.should_not raise_error
  >    end
  > 
  > I'd like to write:
  > 
  >    it { should respond_on_port(80) }
  > 
  > Rspec supports the the syntactic sugar; it's just a matter of adding some "matcher" plugins.
  > 
  > How do other chef users verify that recipes work as expected?
  > 
  > I'm not sure how applicable my approach is to opscode/cookbooks because it relies on having a specific server configuration and can only test a cookbook in the context of that single server.  If we automated the boostrap step so it could be embedded into the rspec setup blocks, it would be possible to test a cookbook in several sample contexts, but the time required to setup each server instance might be prohibitive.
  > 


Andrew Crump < acrump@gmail.com>

  > Integration tests that exercise the service you are building definitely give you the most bang for buck.
  > 
  > We found the feedback cycle slow as well so I wrote chefspec which builds on RSpec to support unit testing cookbooks:
  > 
  > https://github.com/acrmp/chefspec
  > 
  > This basically fakes a convergence and allows you to make assertions about the created resources. At first glance Chef's declarative nature makes this less useful, but once you start introducing conditional execution I've found this to be a time saver.
  > 
  > If you're looking to do CI (which you should be) converging twice goes some way to verifying that your recipes are idempotent.
  > 
  > knife cookbook test is a useful first gate for CI:
  > 
  > http://wiki.opscode.com/display/chef/Knife#Knife-test
