module Tango
  class DanceCard

    def self.instance
      @dance_card ||= DanceCard.new
    end

    def initialize
      @dances = {}
    end

    def dance(name, &block)
      @dances[name] = Dance.new(self, &block)
    end

    def run(name, *args)
      dance_name, step_name = *name.split(":")
      @dances[dance_name].run(step_name, *args)
    end

  end
end
