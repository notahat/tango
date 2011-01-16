require 'dance_builder'

class Dance
  def initialize(&block)
    @steps = {}
    DanceBuilder.new(self).instance_eval(&block)
  end

  def define_step(name, step)
    @steps[name] = step
  end

  def run(step_name)
    @steps[step_name].run
  end
end
