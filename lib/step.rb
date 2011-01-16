require 'step_builder'
require 'step_runner'

class Step
  def initialize(&block)
    StepBuilder.new(self).instance_eval(&block)
  end

  attr_accessor :dance, :met_block, :meet_block

  def run(options = {})
    StepRunner.new(self, options).run
  end
end
