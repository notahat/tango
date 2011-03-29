module Tango
  class Logger
    def self.instance
      @logger ||= Logger.new
    end

    def initialize(io = STDERR)
      @io = io
      @depth = 0
    end

    def enter(step_name)
      @io.puts "#{indent}#{step_name} {\n"
      @depth += 1
    end

    def log(message)
      @io.puts "#{indent}#{message}\n"
    end

    def leave(step_name)
      @depth -= 1
      @io.puts "#{indent}} √ #{step_name}\n"
    end

  private

    def indent
      "  " * @depth
    end

  end
end
