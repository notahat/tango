require 'step_builder'

class Step
  def initialize(&block)
    StepBuilder.new(self).instance_eval(&block)
  end

  attr_accessor :met_block, :meet_block

  def run
    if met_block
      run_with_met_block
    else
      run_without_met_block
    end
  end

  def met?
    met_block.call
  end

  def meet
    meet_block.call
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

end
