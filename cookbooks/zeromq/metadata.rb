maintainer       "Logan Lowell - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      "ZeroMQ: The socket library that acts as a concurrency framework."

depends          "silverware"

recipe           "zeromq::install_from_release", "Installs ZeroMQ"

%w[ debian ubuntu ].each do |os|
  supports os
end
