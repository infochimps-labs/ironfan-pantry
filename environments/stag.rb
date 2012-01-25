name        "stag"
description "Staging environment"

require File.expand_path("_default", File.dirname(__FILE__))

default_attributes(Chef::Mixin::DeepMerge.merge(default_attributes, {
}))

override_attributes(Chef::Mixin::DeepMerge.merge(override_attributes, {
}))
