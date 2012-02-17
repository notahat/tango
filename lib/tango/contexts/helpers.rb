# coding: utf-8

module Tango
  module Contexts
    module Helpers

      def in_context(context, &block)
        Chain.new.in_context(context, &block)
      end

      def in_directory(directory, &block)
        in_context(Directory.new(directory), &block)
      end

      def with_umask(umask, &block)
        in_context(Umask.new(umask), &block)
      end

      def as_user(umask, &block)
        in_context(User.new(umask), &block)
      end

    end
  end
end
