source "http://rubygems.org"

#
# Chef
#

gem 'chef',            ">= 0.10.8"
gem 'ironfan',         "~> 4.5", :path => '../ironfan'
gem 'knife-cookbook-bump', :git => 'git://github.com/Atalanta/knife-cookbook-bump.git'
gem 'berkshelf',       ">= 1.0.1"
gem 'version'

# Everything in the world is being a stupid dick about JSON versions. Pin it to
# the one that doesn't seem to angrify everyone.
gem 'json',            "~> 1.5.4"

#
# Test drivers
#

group :test do
  gem 'rake'
  gem 'bundler',       "~> 1"
  gem 'rspec',         "~> 2.5"
  gem 'redcarpet',   "~> 2"
  gem 'cucumber',      "~> 1.1"
end

#
# Development
#

group :development do
  gem 'yard',          "~> 0.6"
  gem 'jeweler'

  gem 'ruby_gntp'

  gem 'guard',         "~> 1"
  gem 'guard-process', "~> 1"
  gem 'guard-chef',    :git => 'git://github.com/infochimps-forks/guard-chef.git'
  gem 'guard-cucumber'
end

group :support do
  gem 'pry'  # useful in debugging
  gem 'grit' # used in rake scripts for push/pulling cookbooks
end
