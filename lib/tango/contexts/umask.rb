module Tango
  module Contexts
    class Umask
      attr_reader :umask

      def initialize(umask)
        @umask = umask
      end

      def enter
        @old_umask = File.umask(@umask)
      end

      def leave
        File.umask(@old_umask)
      end

    end
  end
end
