module Tango
  class Step
    def initialize(&block)
      @block = block
    end

    attr_accessor :dance
    attr_reader :block

    def run(*args)
      StepRunner.new(self).instance_exec(*args, &block)
    end
  end
end
