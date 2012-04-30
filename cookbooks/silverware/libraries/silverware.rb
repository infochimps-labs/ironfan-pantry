#
# Dependencies for silverware libraries
#
module Ironfan
  module_dir = File.expand_path('..', __FILE__)
  autoload :Component, File.join(module_dir, 'attr_struct.rb')
  autoload :NodeUtils, File.join(module_dir, 'node_utils.rb')
  autoload :Component, File.join(module_dir, 'component.rb')
  autoload :Aspect, File.join(module_dir, 'aspect.rb')
  autoload :Discovery, File.join(module_dir, 'discovery.rb')
  autoload :AttrStruct, File.join(module_dir, 'attr_struct.rb')
end
# require File.expand_path('aspects.rb',     File.dirname(__FILE__))
# require SILVERWARE_DIR("libraries/aspect")
# require SILVERWARE_DIR("libraries/aspects")
# require SILVERWARE_DIR("libraries/discovery")
