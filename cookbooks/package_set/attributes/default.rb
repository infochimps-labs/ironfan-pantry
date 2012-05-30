#
# All but the most hermetic production machines benefit from certain base
# packages -- git, htop, libxml, etc -- be present. Creating a stupid one-line
# cookbook for each is overkill and clutters your runlist. Having a fixed
# 'big_dumping_ground_for_packages' is a proven disaster -- one coder's
# convenience gems is anothers' bundler hell.
#
# Package sets provide
# * visibility: I know *exactly* which miscellaneous packages are installed
# * package sets are repeatable and match the machine's purpose: dev boxes get a
#   variety of kitchen sinks, production boxes get only bare essentials.
# * Fine-grained control over versions, and ability to knock out a conflicting
#   package.
#
# The package_set attribute group defines what package sets to install, and the
# contents of those package sets.
#
# Choose the package sets to install by setting `node[:package_set][:install]`. The
# default is
#
#     default[:package_set][:install] = %w[ base dev sysadmin ]
#
# Targets for `package` resource go in `node[:package_set][:pkgs][{set_name}]`,
# targets for `gem_package` go in `node[:package_set][:gems][{set_name}]`, and so
# forth. For instance, the 'base' group is defined as
#
#     default[:package_set][:pkgs][:base] = %w[ tree git zip openssl ]
#     default[:package_set][:gems][:base] = %w[ bundler rake ]
#
# In your clusters file or a role, you can both specify which sets (if any) the
# machine installs, and modify (for that node or role only) what packages are
# in any given group.
#
# Defining package_set is distributed -- anything can define a 'foo' group by
# setting `node[:package_set][:pkgs][:foo]`, no need to modify this
# cookbook. Selecting *which* packages to install is however unambiguous -- you
# must expressly add the set 'foo' to your node[:package_set][:install] attribute.
#

#
# Package sets to install. Set this in a role -- for example
#
#     default_attributes({
#       :package_set => {
#         :install => %w[ base dev sysadmin ],
#       }
#     })
#
# Later roles can use the "!merge:" feature to knock it out
#
default[:package_set][:install]          = %w[ ]

# --------------------------------------------------------------------------
#
# Package set definitions: related code assets installable as a group
#


default[:package_set][:pkgs][:base]      =  \
  case node.platform
    when 'centos'
      %w[ tree git zip openssl wget curl runit libxslt-devel ]
    else
      %w[ tree git zip openssl wget curl runit libyaml-dev libxslt1-dev ]
  end
default[:package_set][:gems][:base]      = %w[ bundler ]

default[:package_set][:pkgs][:dev]       = \
    case node.platform
      when 'centos'
        %w[ emacs-nox elinks w3m ctags-etags ]
      else
        %w[ tree git zip openssl wget curl runit libyaml-dev libxslt1-dev ]
    end
default[:package_set][:gems][:dev]       = %w[
  extlib json yajl-ruby awesome_print addressable cheat rest-client
  yard jeweler rspec watchr pry wirble hirb highline formatador
  configliere gorillib wukong swineherd hackboxen
  ] + [
    { :name => 'activesupport', :version => '3.1.0', },
    { :name => 'activemodel',   :version => '3.1.0', },
  ]

default[:package_set][:pkgs][:sysadmin]  = \
    case node.platform
      when 'centos'
        %w[ dstat tree chkconfig sysstat nmap ]
      else
        %w[ ifstat htop tree chkconfig sysstat nmap python-software-properties ]
    end
default[:package_set][:gems][:sysadmin]  = %w[]

default[:package_set][:pkgs][:text]      = \
    case node.platform
      when 'centos'
        %w[ libidn-devel libxml2-devel libxslt-devel tidy ]
      else
        %w[ libidn11-dev libxml2-dev libxml2-utils libxslt1-dev tidy ]
    end
default[:package_set][:gems][:text]      = %w[ nokogiri erubis i18n ]

default[:package_set][:pkgs][:ec2]       = %w[ s3cmd ec2-ami-tools ec2-api-tools ]
default[:package_set][:gems][:ec2]       = %w[ fog right_aws ironfan ]

default[:package_set][:pkgs][:vagrant]   = %w[ ifstat htop tree chkconfig sysstat nmap ]
default[:package_set][:gems][:vagrant]   = %w[ vagrant veewee ironfan ]

default[:package_set][:pkgs][:python]    = \
    case node.platform
      when 'centos'
        %w[ python-devel python-setuptools python-simplejson ]
      else
        %w[ python-dev python-setuptools python-simplejson ]
    end

default[:package_set][:gems][:wukong]    = %w[ log4r RedCloth guard htmlentities log4r log_buddy redcarpet simplecov multi_json ]

default[:package_set][:pkgs][:datatools] = %w[
  r-base r-base-dev x11-apps eog texlive-common texlive-binaries dvipng
  ghostscript latex libfreetype6 python-gtk2 python-gtk2-dev python-wxgtk2.8
]

default[:package_set][:pkgs][:emacs]     = \
    case node.platform
      when 'centos'
        %w[ emacs-nox emacs-el ]
      else
        ruby_mode = (node[:languages][:ruby][:version] =~ /^1.9/ ? "ruby1.9.1-elisp" : "ruby") rescue nil
        [ "emacs23-nox", "emacs23-el", "python-mode", ruby_mode, "org-mode" ].compact
    end
