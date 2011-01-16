class StepRunnerContext
  def initialize(step)
    @step = step
  end

  def run(step_name)
    @step.dance.run(step_name)
  end
end
