require File.expand_path('silverware.rb', File.dirname(__FILE__))

# Ill advised predecessor to Gorillib Models. Rip out and replace.

module Ironfan

  class DaemonAspect < Aspect
    register!
  end

  class PortAspect < Aspect
    register!
  end

  class DashboardAspect < Aspect
    register!
  end

  #
  # * scope[:log_dirs]
  # * scope[:log_dir]
  # * flavor: http, etc
  #
  class LogAspect < Aspect
    register!
  end

  #
  # * attributes with a _dir or _dirs suffix
  #
  class DirectoryAspect < Aspect
    def self.plural_handle() :directories ; end
    register!
  end

  #
  # Code assets (jars, compiled libs, etc) that another system may wish to
  # incorporate
  #
  class ExportedAspect < Aspect
    register!
  end

end
