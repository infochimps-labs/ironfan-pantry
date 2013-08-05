#!/usr/bin/env bats

@test "creates minitest directory" {
  [ -d "/var/chef/minitest" ]
}

@test "creates minitest-handler_test1 directory" {
  [ -d "/var/chef/minitest/minitest-handler_test1" ]
}

@test "copies default test" {
  [ -f "/var/chef/minitest/minitest-handler_test1/default_test.rb" ]
}

@test "copies non-default test" {
  [ -f "/var/chef/minitest/minitest-handler_test1/not_default_test.rb" ]
}
        
@test "copies support file" {
  [ -f "/var/chef/minitest/minitest-handler_test1/helpers.rb" ]
}
