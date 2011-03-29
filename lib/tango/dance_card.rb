require 'tango/logger'
require 'tango/noop_logger'

module Tango
  class DanceCard

    def self.instance
      @dance_card ||= DanceCard.new(Logger.new)
    end

    def initialize(logger = nil)
      @logger = logger || NoopLogger.new
      @dances = {}
    end

    def dance(name, &block)
      @dances[name] = Dance.new(self, &block)
    end

    def run(name, *args)
      dance_name, step_name = *name.split(":")
      @logger.enter(name)
      @dances[dance_name].run(step_name, *args)
      @logger.leave(name)
    end

    def log(message)
      @logger.log(message)
    end

  end
end
