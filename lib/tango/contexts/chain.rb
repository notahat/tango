require 'tango/contexts/directory'
require 'tango/contexts/umask'
require 'tango/contexts/user'

module Tango
  module Contexts
    class Chain

      def initialize
        @contexts = []
      end

      def in_directory(directory, &block)
        append_context(Directory.new(directory), &block)
      end

      def as_user(username, &block)
        append_context(User.new(username), &block)
      end

      def with_umask(umask, &block)
        append_context(Umask.new(umask), &block)
      end

    private

      def append_context(context)
        @contexts << context
        if block_given?
          @contexts.each {|context| context.enter }
          begin
            yield
          ensure
            @contexts.reverse.each {|context| context.exit }
          end
        else
          self
        end
      end

    end
  end
end

