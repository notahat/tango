module Tango
  class DanceBuilder

    def initialize(dance)
      @dance = dance
    end

    def step(name, &block)
      @dance.define_step(name, &block)
    end

  end
end
