class StepBuilder
  def initialize(step)
    @step = step
  end

  def met?(&block)
    @step.met_block = block
  end

  def meet(&block)
    @step.meet_block = block
  end
end
