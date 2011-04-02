require 'tango/as_user'
require 'tango/met_and_meet'
require 'tango/shell'

module Tango
  class Namespace
    include AsUser
    include MetAndMeet
    include Shell
    
    def self.step(step_name, &block)
      define_method(step_name, &block)
    end

    def run(step_name, *args)
      description = "#{self.class.name}.#{step_name}"
      description << "(" + args.map {|arg| arg.inspect }.join(", ") + ")" unless args.empty?

      logger.enter(description)
      send(step_name, *args)
      logger.leave(description)
    end

    def log(message)
      logger.log(message)
    end

    def log_raw(message)
      logger.log_raw(message)
    end

    def logger
      Logger.instance
    end

  end
end
