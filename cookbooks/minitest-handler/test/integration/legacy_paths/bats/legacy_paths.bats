#!/usr/bin/env bats

@test "copies legacy_paths test" {
  [ -f "/var/chef/minitest/minitest-handler_test2/legacy_paths_test.rb" ]
}
        
@test "copies support file" {
  [ -f "/var/chef/minitest/minitest-handler_test2/support/helpers.rb" ]
}

@test "no other tests copied" {
  count=$(find /var/chef/minitest/minitest-handler_test2/ -name '*_test.rb' | wc -l)
  [ "$count" == "1" ]
}

