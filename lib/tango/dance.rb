module Tango
  class Dance

    def initialize(&block)
      @steps = {}
      DanceBuilder.new(self).instance_eval(&block)
    end

    def define_step(name, &block)
      raise StepAlreadyDefinedError, "Step #{name} already defined" if @steps.has_key?(name)
      @steps[name] = block
    end

    def run(step_name, *args)
      raise UndefinedStepError, "Step #{step_name} not defined" unless @steps.has_key?(step_name)
      StepRunner.new(self).instance_exec(*args, &@steps[step_name])
    end

  end
end
