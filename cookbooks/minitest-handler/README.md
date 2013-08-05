Cookbook: minitest-handler<br/>
Author: Bryan W. Berry <bryan.berry@gmail.com><br/>
Author: Bryan McLellan <btm@loftninjas.org><br/>
Author: David Petzel <davidpetzel@gmail.com><br/>
Copyright: 2012 Opscode, Inc.<br/>
License: Apache 2.0<br/>

Description
===========

# <a name="title"></a> minitest-handler [![Build Status](https://secure.travis-ci.org/btm/minitest-handler-cookbook.png?branch=master)](http://travis-ci.org/btm/minitest-handler-cookbook)

This cookbook utilizes the minitest-chef-handler project to facilitate
cookbook testing. By default, minitest-handler will collect all the
tests in your cookbook_path and run them. 

minitest-chef-handler project: https://github.com/calavera/minitest-chef-handler<br/>
stable minitest-handler cookbook: http://community.opscode.com/cookbooks/minitest-handler<br/>
minitest-handler cookbook development: https://github.com/btm/minitest-handler-cookbook<br/>

*Note*: Version 0.1.8 deprecated use of
files/default/tests/minitest/*_test.rb and the location of support
files. Test files should now be located in
files/default/test/*_test.rb
*Note*: Version 0.1.0 added a change that breaks backward compatibility. The minitest-handler now only loads<br/>
test files named "<recipe-name>_test.rb" rather than all test files in the path files/default/test/*_test.rb

If you have any helper libraries, they should match files/default/test/*helper*.rb

Attributes
==========

* node[:minitest][:path] - Location to store and find tests, defaults
  to `/var/chef/minitest`
* node[:minitest][:recipes] - defaults to empty and is populated with
  the names of all recipes included during the chef run, whether by
  insertion to the run_list, inclusion through a role, or added with
  `include_recipe`. If you only want tests for select recipes to run,
  override this value with the names of the recipes that you want tested.
* node[:minitest][:filter] - filter test names on a pattern
* node[:minitest][:seed] - set random seed
* node[:minitest][:ci_reports] - path to write out the result of each
  test in a JUnit-compatible XML file, parseable by many CI platforms
* node[:minitest][:tests] - Test files to run, defaults to `**/*_test.rb`

Usage
=====

* add 'recipe[minitest-handler]' somewhere on your run_list,
  preferably last
* place tests in 'files/default/test/' with the name 'your-recipe-name_test.rb' (default recipe is named 'default_test.rb')
* put any helper functions you have in files/default/test/spec_helper.rb but
  minitest-handler will ensure that you have access to any file that
  matches the glob files/test/*helper.rb

[Minitest](https://github.com/seattlerb/minitest)

Examples
========

### Traditional minitest

    class TestApache2 < MiniTest::Chef::TestCase
      def test_that_the_package_installed
        case node[:platform]
        when "ubuntu","debian"
          assert system('apt-cache policy apache2 | grep Installed | grep -v none')
        end
      end

      def test_that_the_service_is_running
        assert system('/etc/init.d/apache2 status')
      end

      def test_that_the_service_is_enabled
        assert File.exists?(Dir.glob("/etc/rc5.d/S*apache2").first)
      end
    end



### Using minitest/spec

    require 'minitest/spec'

    describe_recipe 'ark::test' do

      it "installed the unzip package" do
        package("unzip").must_be_installed
      end

      it "dumps the correct files into place with correct owner and group" do
        file("/usr/local/foo_dump/foo1.txt").must_have(:owner, "foobarbaz").and(:group, "foobarbaz")
      end

     end

For more detailed examples, see [here](https://github.com/calavera/minitest-chef-handler/blob/v0.4.0/examples/spec_examples/files/default/tests/minitest/example_test.rb)


### Testing this cookbook

This cookbook currently uses [test-kitchen 1.0](https://github.com/opscode/test-kitchen/tree/1.0) and the
[kitchen-lxc](https://github.com/portertech/kitchen-lxc) driver to run
tests. The easiest way to put everything in place for proper lxc
functioning is to install the vagabond gem and execute `vagabond
init`. This command will run chef-solo to configure LXC and put the
proper LXC templates in place.

All tests are written using
[BATS](https://github.com/sstephenson/bats), which is essentially
bash. I did this because I did not want to use minitest-handler or
minitest-chef-handler to test itself. For more examples of bats than are in this cookbook, see
the [chef-rvm](https://github.com/fnichol/chef-rvm), [chef-ruby_build](https://github.com/fnichol/chef-ruby_build), and [chef-rbenv](https://github.com/fnichol/chef-rbenv) cookbooks.
