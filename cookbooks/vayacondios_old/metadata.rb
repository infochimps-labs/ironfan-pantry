maintainer       "Dhruv Bansal"
maintainer_email "dhruv@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      "Installs/Configures Vayacondios"

recipe           "vayacondios_old::default",  "Installs Vayacondios API server."

%w[nginx silverware git].each do |cb|
  depends cb
end

%w[ debian ubuntu ].each do |os|
  supports os
end
