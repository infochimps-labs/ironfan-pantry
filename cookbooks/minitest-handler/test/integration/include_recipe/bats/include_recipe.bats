#!/usr/bin/env bats

@test "copies include_recipe test" {
  [ -f "/var/chef/minitest/minitest-handler_test2/include_recipe_test.rb" ]
}

