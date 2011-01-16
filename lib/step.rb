require 'step_builder'
require 'step_runner'

class Step
  def initialize(&block)
    StepBuilder.new(self).instance_eval(&block)
  end

  attr_accessor :dance, :met_block, :meet_block

  def run
    @runner = StepRunner.new(self)
    if met_block
      run_with_met_block
    else
      run_without_met_block
    end
  end

  def met?
    @runner.instance_eval(&met_block)
  end

  def meet
    @runner.instance_eval(&meet_block)
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
