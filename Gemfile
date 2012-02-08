source "http://rubygems.org"

gem 'chef',          "= 0.10.8"
gem 'cluster_chef',  "~> 3.0.12"

group :development do
  gem 'rake'
  gem 'bundler',     "~> 1"
  gem 'rspec',       "~> 2.5"
  gem 'yard',        "~> 0.6"
end

group :vagrant do
  # note: this will crap the bed because chef and vagrant are too specific about
  # their net ssh version. If you change vagrant's gemspec to have
  #   s.add_dependency(%q<net-ssh>, ["~> 2.1"])
  gem 'vagrant',    "~> 0.9.5"
  gem 'veewee',     "~> 0.2.3"

  # gem 'vagrant',    "~> 0.8"
  # gem 'veewee',     "= 0.2.2"
end

group :support do
  gem 'pry'  # useful in debugging
  gem 'grit' # used in rake scripts for push/pulling cookbooks
end
