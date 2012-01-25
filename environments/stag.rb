name        "stag"
description "Staging environment"

require File.expand_path("_default", File.dirname(__FILE__))

default_attributes(Chef::Mixin::DeepMerge.merge({
}))

override_attributes(Chef::Mixin::DeepMerge.merge({
}))

# cookbook "foo", "= 0.1.0"
# cookbook "bar", "~> 0.1"
# cookbook "bar", "~> 0.1.0"
# cookbook "baz", "< 0.1.0"
