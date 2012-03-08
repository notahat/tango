# coding: utf-8

require 'tango/config_files'
require 'tango/contexts/helpers'
require 'tango/helpers/file_manipulation_helpers'
require 'tango/delegate'
require 'tango/fetch'
require 'tango/met_and_meet'
require 'tango/shell'

module Tango
  class Runner
    include ConfigFiles
    include Contexts::Helpers
    include Delegate
    include Fetch
    include MetAndMeet
    include Shell
    include Helpers::FileManipulationHelpers

    def self.step(step_name, &block)
      define_method(step_name) do |*args|
        description = step_description(step_name, args)

        logger.begin_step(description)
        begin
          result = instance_exec(*args, &block)
        rescue StandardError
          logger.step_not_met(description)
          raise
        else
          logger.step_met(description)
        end

        result
      end
    end

    def step_description(step_name, args)
      description = "#{self.class.name}.#{step_name}"
      description << "(" + args.map {|arg| arg.inspect }.join(", ") + ")" unless args.empty?
      description
    end

    delegate :log, :log_raw, :to => :logger

    def logger
      Logger.instance
    end

  end
end
