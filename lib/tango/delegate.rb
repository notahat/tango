module Tango
  module Delegate
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def delegate(*methods)
        options = methods.pop
        methods.each do |method|
          define_method(method) do |*args|
            send(options[:to]).send(method, *args)
          end
        end
      end

    end

  end
end


