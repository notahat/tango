require 'dep_builder'

class Dep
  def initialize(&block)
    DepBuilder.new(self).instance_eval(&block)
  end

  attr_accessor :meet_block

  def run
    meet_block.call
  end
end
