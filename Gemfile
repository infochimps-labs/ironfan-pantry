source "http://rubygems.org"

gem 'chef',          "= 0.10.8"
gem 'cluster_chef',  "~> 3.0.12"

group :development do
  gem 'rake'
  gem 'bundler',     "~> 1"
  gem 'rspec',       "~> 2.5"
  gem 'yard',        "~> 0.6"

  gem 'ruby_gntp'

  gem 'guard'
  gem 'guard-process'
  gem 'guard-chef'
end

group :support do
  gem 'pry'  # useful in debugging
  gem 'grit' # used in rake scripts for push/pulling cookbooks
end
