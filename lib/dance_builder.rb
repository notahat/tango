require 'step'

class DanceBuilder
  def initialize(dance)
    @dance = dance
  end

  def step(name, &block)
    @dance.define_step(name, Step.new(&block))
  end
end
