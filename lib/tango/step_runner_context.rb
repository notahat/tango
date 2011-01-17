module Tango
  class StepRunnerContext

    def initialize(step)
      @step = step
    end

    def run(step_name, options = {})
      @step.dance.run(step_name, options)
    end

  end
end
