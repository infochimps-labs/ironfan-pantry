name             "minitest-handler_test1"
maintainer       "Bryan Berry"
maintainer_email "bryan.berry@gmail.com"
license          "Apache 2.0"
description      "Installs and configures minitest-chef-handler"
version          "0.0.1"

%w{ chef_handler minitest-handler }.each {|ckbk| depends ckbk }
