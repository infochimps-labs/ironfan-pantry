maintainer       "Philip (flip) Kromer - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      "Creates and serves a lightweight pluggable dashboard for a machine. Requires only the busybox httpd that is typically pre-installed with your OS"

depends          "runit"
depends          "silverware"

recipe           "minidash::default",                   "Dashboard for this machine: index of services and their dashboard snippets"
recipe           "minidash::server",                    "Lightweight thttpd server to render minidash dashboards"

%w[ debian ubuntu ].each do |os|
  supports os
end

attribute "minidash/conf_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/etc/minidash"

attribute "minidash/log_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/var/log/minidash"

attribute "minidash/home_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/var/lib/minidash"

attribute "minidash/user",
  :display_name          => "",
  :description           => "",
  :default               => "root"

attribute "minidash/port",
  :display_name          => "",
  :description           => "",
  :default               => "5678"

attribute "minidash/run_state",
  :display_name          => "",
  :description           => "",
  :default               => "start"
