maintainer       "Dhruv Bansal - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      "Log integration -- coordinates rotation and archival of logs."

recipe           "log_integration::logrotate", "Rotates logs using lograte."

%w[ debian ubuntu ].each do |os|
  supports os
end

depends 'silverware'


attribute "log_integration/logrotate/conf_dir",
  :display_name          => "",
  :description           => "Directory in which to write logrotate configuration files.",
  :default               => "/etc/logrotate.d"

attribute "log_integration/logrotate/conf_prefix",
  :display_name          => "",
  :description           => "Prefix for created logrotate configuration files.",
  :default               => nil
