require 'tango/as_user'
require 'tango/delegate'
require 'tango/met_and_meet'
require 'tango/shell'

module Tango
  class Namespace
    include AsUser
    include Delegate
    include MetAndMeet
    include Shell
    
    def self.step(step_name, &block)
      define_method(step_name) do |*args|
        description = step_description(step_name, args)

        logger.enter(description)
        result = instance_exec(*args, &block)
        logger.leave(description)

        result
      end
    end

    def step_description(step_name, args)
      description = "#{self.class.name}.#{step_name}"
      description << "(" + args.map {|arg| arg.inspect }.join(", ") + ")" unless args.empty?
      description
    end

    alias_method :run, :send

    delegate :log, :log_raw, :to => :logger

    def logger
      Logger.instance
    end

  end
end
