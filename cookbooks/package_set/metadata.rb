maintainer       "Philip (flip) Kromer - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      "Installs extra packages that don't warrant their own cookbook (tree, htop, colordiff and so on), yet still provides visibility, dev-vs-production tradeoffs, and fine-grained version control where necessary."


recipe           "package_set::default",               "Base configuration for package_set"

%w[ debian ubuntu ].each do |os|
  supports os
end

attribute "package_set/install",
  :display_name          => "Package sets to install",
  :description           => "Choose the package sets to install. See package_set/pkgs and package_set/gems for their contents.",
  :type                  => "array",
  :default               => ["base", "dev", "sysadmin"]

attribute "package_set/pkgs/base",
  :display_name          => "Base set of packages, suitable for all machines",
  :description           => "Base set of packages, suitable for all machines",
  :type                  => "array",
  :default               => ["tree", "git", "zip", "openssl", "wget", "curl", "runit", "libyaml-dev", "libxslt1-dev"]

attribute "package_set/pkgs/dev",
  :display_name          => "",
  :description           => "",
  :type                  => "array",
  :default               => ["emacs23-nox", "elinks", "w3m-el", "colordiff", "ack", "exuberant-ctags"]

attribute "package_set/pkgs/sysadmin",
  :display_name          => "",
  :description           => "",
  :type                  => "array",
  :default               => ["ifstat", "htop", "tree", "chkconfig", "sysstat", "nmap", "python-software-properties"]

attribute "package_set/pkgs/text",
  :display_name          => "",
  :description           => "",
  :type                  => "array",
  :default               => ["libidn11-dev", "libxml2-dev", "libxml2-utils", "libxslt1-dev", "tidy"]

attribute "package_set/pkgs/ec2",
  :display_name          => "",
  :description           => "",
  :type                  => "array",
  :default               => ["s3cmd", "ec2-ami-tools", "ec2-api-tools"]

attribute "package_set/pkgs/vagrant",
  :display_name          => "",
  :description           => "",
  :type                  => "array",
  :default               => ["ifstat", "htop", "tree", "chkconfig", "sysstat", "nmap"]

attribute "package_set/pkgs/python",
  :display_name          => "",
  :description           => "",
  :type                  => "array",
  :default               => ["python-dev", "python-setuptools", "python-simplejson"]

attribute "package_set/pkgs/datatools",
  :display_name          => "",
  :description           => "",
  :type                  => "array",
  :default               => ["r-base", "r-base-dev", "x11-apps", "eog", "texlive-common", "texlive-binaries", "dvipng", "ghostscript", "latex", "libfreetype6", "python-gtk2", "python-gtk2-dev", "python-wxgtk2.8"]

attribute "package_set/pkgs/emacs",
  :display_name          => "",
  :description           => "",
  :type                  => "array",
  :default               => ["emacs23-nox", "emacs23-el", "python-mode", "ruby1.9.1-elisp", "org-mode"]

attribute "package_set/gems/base",
  :display_name          => "",
  :description           => "",
  :type                  => "array",
  :default               => ["bundler"]

attribute "package_set/gems/dev",
  :display_name          => "",
  :description           => "",
  :type                  => "array",
  :default               => ["extlib", "json", "yajl-ruby", "awesome_print", "addressable", "cheat", "rest-client", "yard", "jeweler", "rspec", "watchr", "pry", "wirble", "hirb", "highline", "formatador", "configliere", "gorillib", "wukong", "swineherd", "hackboxen", {:name=>"activesupport", :version=>"3.1.0"}, {:name=>"activemodel", :version=>"3.1.0"}]

attribute "package_set/gems/sysadmin",
  :display_name          => "",
  :description           => "",
  :default               => ""

attribute "package_set/gems/text",
  :display_name          => "",
  :description           => "",
  :type                  => "array",
  :default               => ["nokogiri", "erubis", "i18n"]

attribute "package_set/gems/ec2",
  :display_name          => "",
  :description           => "",
  :type                  => "array",
  :default               => ["fog", "right_aws", "ironfan"]

attribute "package_set/gems/vagrant",
  :display_name          => "",
  :description           => "",
  :type                  => "array",
  :default               => ["vagrant", "veewee", "ironfan"]
