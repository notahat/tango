# coding: utf-8

module Tango
  class Logger
    def self.instance
      @logger ||= Logger.new
    end

    def initialize(io = STDERR)
      @io = io
      @depth = 0
    end

    def begin_step(step_name)
      log "#{step_name} {"
      @depth += 1
    end

    def step_met(step_name)
      @depth -= 1
      log "} √ #{step_name}"
    end

    def step_not_met(step_name)
      @depth -= 1
      log "} ✕ #{step_name}\n\n"
    end

    def log(message)
      @io.puts "#{indent}#{message}"
    end

    def log_raw(message)
      @io.write message
    end

  private


    def indent
      "  " * @depth
    end

  end
end

