module Tango
  module Contexts
    class Directory

      def initialize(directory)
        @directory = directory
      end

      def enter
        @old_directory = Dir.getwd
        Dir.chdir(@directory)
      end

      def exit
        Dir.chdir(@old_directory)
      end

    end
  end
end
