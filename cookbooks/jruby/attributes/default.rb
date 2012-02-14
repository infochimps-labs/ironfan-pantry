default[:jruby][:home_dir]          = '/usr/local/share/jruby'

default[:jruby][:version]           = "1.6.5"
default[:jruby][:release_url]       = "http://jruby.org.s3.amazonaws.com/downloads/:version:/jruby-bin-:version:.tar.gz"

# what version of ruby to behave like
default[:jruby][:ruby_version]      = "1.9"

default[:java][:java_home]          = '/usr/lib/jvm/java-6-sun/jre'
