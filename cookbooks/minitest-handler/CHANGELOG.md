Changelog
=====

### v0.2.0

The path for placing your tests is now files/default/test/ however
this change is backwards compatible, the minitest-hander::default
recipe will also look in the old location
files/default/tests/minitest/

You should name your support files something that matches
files/default/test/*helper*.rb. The old support support/ location will
also be honored.

New Features:
* You can place minitest-handler anywhere in your run_list and it will
work. I like to use `include_recipe` to add it.
* You can easily limit which tests are run by setting the array
node.set[:minitest][:recipes]  with only those recipes that you want
tested
* minitest-handler now also will run test for any recipes added to the
run_list via include_recipe, environment, or roles.

Niceties:
* Added tests w/ test-kitchen 1.0, kitchen-lxc, and BATS
* huge code cleanup

### v0.0.9

* add windows support tks to David Petzel
* add travis-ci integration
* change maintainer to Bryan W. Berry

	
### v0.0.7

* Add better examples to the readme 
* pass foodcritic
	
### v0.0.6

* MINITEST-HANDLER-COOKBOOK-12 ensure minitest gem used and not the standard library in 1.9
* MINITEST-HANDLER-COOKBOOK-11 Add support for Chef-Solo
* Create the /var/chef/minitest directory if it doesn't already exist


### v0.0.5 

* Install the minitest-chef-handler gem instead of downloading from github directly
* Remove tests from cookbooks no longer in the run list

### v0.0.4

Add examples/ top level directory (may not work)
