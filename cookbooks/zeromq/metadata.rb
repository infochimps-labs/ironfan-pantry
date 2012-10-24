maintainer       "Logan Lowell - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
version          "0.0.2"

description      "ZeroMQ: The socket library that acts as a concurrency framework."

depends          "silverware"

recipe           "zeromq::install_from_release", "Installs ZeroMQ"

%w[ debian ubuntu ].each do |os|
  supports os
end
