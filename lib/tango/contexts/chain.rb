require 'tango/contexts/helpers'

module Tango
  module Contexts
    class Chain

      include Helpers
    
      def initialize
        @contexts = []
      end

      def in_context(context, &block)
        @contexts << context
        if block_given?
          call_in_contexts(&block)
        else
          self
        end
      end

    private

      def call_in_contexts
        @contexts.each {|context| context.enter }
        begin
          yield
        ensure
          @contexts.reverse.each {|context| context.exit }
        end
      end

    end
  end
end

