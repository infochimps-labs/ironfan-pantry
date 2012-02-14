
# should be 1.9
jruby -e 'puts RUBY_VERSION'
jruby --1.9 -e 'puts RUBY_VERSION'
JRUBY_OPTS="--1.9" jruby -e 'puts RUBY_VERSION'
jruby19 -e 'puts RUBY_VERSION'

# should be 1.8
jruby --1.8 -e 'puts RUBY_VERSION'
JRUBY_OPTS="--1.8" jruby -e 'puts RUBY_VERSION'
jruby18 -e 'puts RUBY_VERSION'

.../chef-jgem should exist
output of .../chef-jgem list should include activemodel and foo and bar
