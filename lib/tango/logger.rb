# coding: utf-8

module Tango
  module TermANSIColorStubs
    [:red, :green, :yellow].each do |color|
      define_method(color) { |str| str }
    end
  end

  class Logger
    begin
      require 'term/ansicolor'
      include Term::ANSIColor
    rescue LoadError
      include TermANSIColorStubs
    end

    def self.instance
      @logger ||= Logger.new
    end

    def initialize(io = STDERR)
      @io = io
      @depth = 0
    end

    def begin_step(step_name)
      log "#{yellow(step_name)} {"
      @depth += 1
    end

    def step_met(step_name)
      @depth -= 1
      log "} #{green("√ #{step_name}")}"
    end

    def step_not_met(step_name)
      @depth -= 1
      log "} #{red("✕ #{step_name}")}\n\n"
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

