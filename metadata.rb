maintainer       "Philip (flip) Kromer - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "3.0.3"

description      "Creates and serves a lightweight pluggable dashboard for a machine"

depends          "runit"
depends          "metachef"

recipe           "dashpot",         "Dashboard for this machine: index of services and their dashboard snippets"
recipe           "dashpot::server", "Lightweight thttpd server to render dashpot dashboards"

%w[ debian ubuntu ].each do |os|
  supports os
end

attribute "dashpot/conf_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/etc/dashpot"

attribute "dashpot/log_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/var/log/dashpot"

attribute "dashpot/home_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/etc/dashpot"

attribute "dashpot/user",
  :display_name          => "",
  :description           => "",
  :default               => "root"
