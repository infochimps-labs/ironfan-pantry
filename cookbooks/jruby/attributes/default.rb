default[:jruby][:home_dir]          = '/usr/local/share/jruby'

default[:jruby][:version]           = "1.6.7.2"
default[:jruby][:release_url]       = "http://jruby.org.s3.amazonaws.com/downloads/:version:/jruby-bin-:version:.tar.gz"

# what version of ruby to behave like
default[:jruby][:ruby_version]      = "1.9"
