module Tango
  module Contexts
    class Directory
      attr_reader :directory

      def initialize(directory)
        @directory = directory
      end

      def enter
        @old_directory = Dir.getwd
        Dir.chdir(@directory)
      end

      def leave
        Dir.chdir(@old_directory)
      end

    end
  end
end
