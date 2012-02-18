$LOAD_PATH.unshift(File.dirname(__FILE__))

# $LOAD_PATH.unshift(File.expand_path('../../../lib'), File.dirname(__FILE__))
# require 'cluster_chef/dsl_object'

#
# Dependencies for silverware libraries
#
require File.expand_path('attr_struct.rb', File.dirname(__FILE__))
require File.expand_path('node_utils.rb',  File.dirname(__FILE__))
require File.expand_path('component.rb',   File.dirname(__FILE__))
require File.expand_path('aspect.rb',      File.dirname(__FILE__))
require File.expand_path('discovery.rb',   File.dirname(__FILE__))

# require File.expand_path('aspects.rb',     File.dirname(__FILE__))
# require SILVERWARE_DIR("libraries/aspect")
# require SILVERWARE_DIR("libraries/aspects")
# require SILVERWARE_DIR("libraries/discovery")
