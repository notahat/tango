require 'derp/as_user'
require 'derp/config_files'
require 'derp/delegate'
require 'derp/fetch'
require 'derp/met_and_meet'
require 'derp/shell'
require 'derp/working_directory'

module Derp
  class Runner
    include AsUser
    include ConfigFiles
    include Delegate
    include Fetch
    include MetAndMeet
    include Shell
    include WorkingDirectory
    
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
