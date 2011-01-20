module Tango
  class Step
    def initialize(&block)
      @block = block
    end

    attr_accessor :dance
    attr_reader :block

    def run(options = {})
      StepRunner.new(self).instance_exec(options, &block)
    end
  end
end
