require 'step_runner_context'

class StepRunner
  def initialize(step)
    @step    = step
    @context = StepRunnerContext.new(@step)
  end

  def run
    if @step.met_block
      run_with_met_block
    else
      run_without_met_block
    end
  end

private

  def run_with_met_block
    unless met?
      meet
      raise "Couldn't meet" unless met?
    end
  end

  def run_without_met_block
    meet
  end

  def met?
    @context.instance_eval(&@step.met_block)
  end

  def meet
    @context.instance_eval(&@step.meet_block)
  end

end
