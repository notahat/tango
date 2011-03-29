require 'tango/met_and_meet'

module Tango
  class Namespace
    include MetAndMeet
    
    def self.step(step_name, &block)
      define_method(step_name, &block)
    end

    def self.run(step_name, *args)
      logger.enter("#{name}.#{step_name}")
      new.send(step_name, *args)
      logger.leave("#{name}.#{step_name}")
    end

    def run(step_name, *args)
      self.class.run(step_name, *args)
    end

    def log(message)
      self.class.logger.log(message)
    end

  private

    def self.logger
      Logger.instance
    end

  end
end
