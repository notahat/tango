require 'tango/contexts/chain'
require 'tango/contexts/directory'
require 'tango/contexts/helpers'
require 'tango/contexts/umask'
require 'tango/contexts/user'

module Tango
  module Contexts
    class NotInContextError < StandardError; end

    def current
      Thread.current[:tango_contexts] ||= []
    end
    module_function :current

    def context_for(name)
      current.reverse.find { |context| canonical_name(context) == name.to_s }
    end
    module_function :context_for

    def canonical_name(context)
      context.class.name.split('::').last.gsub(/([a-z])([A-Z])/, '\1_\2').downcase
    end
    module_function :canonical_name
  end
end