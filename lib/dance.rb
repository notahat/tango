require 'dance_builder'

class Dance
  class StepAlreadyDefinedError < RuntimeError; end
  class UndefinedStepError < RuntimeError; end

  def initialize(&block)
    @steps = {}
    DanceBuilder.new(self).instance_eval(&block)
  end

  def define_step(name, step)
    raise StepAlreadyDefinedError, "Step #{name} already defined" if @steps.has_key?(name)
    step.dance   = self
    @steps[name] = step
  end

  def run(step_name)
    raise UndefinedStepError, "Step #{step_name} not defined" unless @steps.has_key?(step_name)
    @steps[step_name].run
  end
end
