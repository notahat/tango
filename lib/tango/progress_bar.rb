# encoding: utf-8

module Tango
  class MustImplementProgressMethodError < RuntimeError; end

  class ProgressBar
    WIDTH = 40
    REFRESH_RATE = 0.2

     module TermANSIColorStubs
       def green(str);
         str
       end
     end

    begin
       require 'term/ansicolor'
       include Term::ANSIColor
     rescue LoadError
       include TermANSIColorStubs
     end

    def self.show(runner, &block)
      Thread.abort_on_exception = true
      new(runner, block).start
    end

    def initialize(runner, block)
      @runner = runner
      @block = block
      @buf = ''
      ensure_runner_responds_to_percentage
    end

    def start
      @thread = Thread.new do
        loop do
          progress = @runner.progress
          @runner.log_raw(progress_bar(progress))
          break if @stop || progress.to_i == 100
          sleep REFRESH_RATE
          clear
        end
      end

      @block.call ensure stop
    end

    def stop
      @stop = true
      @thread.join if @thread
      clear
    end

    protected

    def clear
      @runner.log_raw("\b \b" * (@buf.size * 3))
    end

    def progress_bar(progress)
      @buf = "#{' ' * @runner.logger.depth} |"
      blocks = ((WIDTH * progress.to_f) / 100.0).floor
      @buf += green('❚') * blocks
      @buf += ' ' * (WIDTH - blocks)
      @buf += "| #{progress.to_i}%"
    end

    def ensure_runner_responds_to_percentage
      raise MustImplementProgressMethodError if !@runner.respond_to?(:progress)
    end
  end
end