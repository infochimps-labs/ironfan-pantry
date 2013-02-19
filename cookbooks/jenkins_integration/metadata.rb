maintainer       "Nathaniel Eliot"
maintainer_email "temujin9@infochimps.com"
license          "Apache 2.0"
description      "Installs/Configures jenkins_integration"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

recipe           "jenkins_integration::default",        "Base of jenkins_integration"
recipe           "jenkins_integration::cookbook_ci",    "Ironfan Cookbook CI"
