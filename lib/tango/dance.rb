module Tango
  class Dance

    def initialize(&block)
      @steps = {}
      instance_eval(&block)
    end

    def step(name, &block)
      raise StepAlreadyDefinedError, "Step #{name} already defined" if @steps.has_key?(name)
      @steps[name] = block
    end

    def run(step_name, *args)
      step = @steps[step_name]
      raise UndefinedStepError, "Step #{step_name} not defined" if step.nil?
      StepRunner.new(self).instance_exec(*args, &step)
    end

  end
end
