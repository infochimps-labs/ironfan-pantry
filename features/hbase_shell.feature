echo 'puts [RUBY_VERSION, JRUBY_VERSION, RbConfig::CONFIG["libdir"] ].inspect' | JRUBY_OPTS=--1.8 JRUBY_HOME="" /usr/lib/hbase/bin/hbase shell

["1.8.7", "1.6.0", "file:/usr/lib/hbase/lib/jruby-complete-1.6.0.jar!/META-INF/jruby.home/lib"]

echo 'puts [RUBY_VERSION, JRUBY_VERSION, RbConfig::CONFIG["libdir"] ].inspect' | JRUBY_OPTS=--1.9 JRUBY_HOME="" /usr/lib/hbase/bin/hbase shell

["1.9.2", "1.6.0", "file:/usr/lib/hbase/lib/jruby-complete-1.6.0.jar!/META-INF/jruby.home/lib"]

echo 'puts [RUBY_VERSION, JRUBY_VERSION, RbConfig::CONFIG["libdir"] ].inspect' | JRUBY_OPTS=--1.9 JRUBY_HOME="/usr/local/share/jruby" /usr/lib/hbase/bin/hbase shell

["1.9.2", "1.6.5", "/usr/local/share/jruby-1.6.5/lib"]


