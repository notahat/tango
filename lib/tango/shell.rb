require 'ostruct'

module Tango
  module Shell

    def shell(command, *args)
      options = { :echo => true }
      options.merge!(args.pop) if args.last.is_a?(Hash)

      log "% #{command} #{args.join(' ')}\n\n" if options[:echo]

      pid, pipe = fork_and_exec(command, *args)
      output    = collect_output(pipe, options[:echo])
      Process.waitpid(pid)
      pipe.close

      log "" if options[:echo]

      OpenStruct.new(
        :output     => output,
        :status     => $?.exitstatus,
        :succeeded? => $?.success?,
        :failed?    => !$?.success?
      )
    end

  private

    def fork_and_exec(command, *args)
      read_end, write_end = IO.pipe
      pid = fork do
        read_end.close
        STDOUT.reopen(write_end)
        STDERR.reopen(write_end)
        exec(command, *args)
      end
      write_end.close

      return pid, read_end
    end

    def collect_output(pipe, echo = true)
      output = ""

      begin
        loop do
          partial = pipe.readpartial(4096)
          log_raw(partial) if echo
          output << partial
        end
      rescue EOFError
      end

      output
    end

  end
end

