module Tango
  class StepRunner

    def initialize(step)
      @step = step
    end

    def met?(&met_block)
      @met_block = met_block
    end

    def meet(&meet_block)
      unless instance_eval(&@met_block)
        instance_eval(&meet_block)
        raise "Couldn't meet" unless instance_eval(&@met_block)
      end
    end

    def run(step_name, options = {})
      @step.dance.run(step_name, options)
    end

  end
end
