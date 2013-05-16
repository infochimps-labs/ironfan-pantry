require File.expand_path('silverware.rb', File.dirname(__FILE__))

# Ill advised predecessor to Gorillib Models. Rip out and replace.

module Ironfan

  class Aspect
    include AttrStruct
    extend  Ironfan::NodeUtils

    dsl_attr(:component, :kind_of => Ironfan::Component)
    dsl_attr(:name,      :kind_of => [String, Symbol])

    def self.register!
      Ironfan::Component.has_aspect(self)
    end

    # strip off module part and '...Aspect' from class name
    # @example Ironfan::FooAspect.handle # :foo
    def self.handle
      @handle ||= self.name.to_s.gsub(/.*::(\w+)Aspect\z/,'\1').gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase.to_sym
    end

    def self.plural_handle
      "#{handle}s".to_sym
    end

  end
end
