module Tango
  # A step's block is instance_execed against one of these. It provides all the
  # methods accessible from within the step.
  class StepRunner

    def initialize(dance = nil)
      @dance = dance
    end

    def met?(&met_block)
      @met_block = met_block
    end

    def meet(&meet_block)
      raise MeetWithoutMetError if @met_block.nil?
      unless instance_eval(&@met_block)
        instance_eval(&meet_block)
        raise CouldNotMeetError unless instance_eval(&@met_block)
      end
    end

    def run(step_name, *args)
      @dance.run(step_name, *args)
    end

  end
end
