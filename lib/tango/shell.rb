require 'ostruct'

module Tango
  module Shell

    def shell(command, *args)
      options = { :echo => true, :env_vars => {} }
      options.merge!(args.pop) if args.last.is_a?(Hash)

      if user_context = Tango::Contexts.context_for(:user)
        command, args = command_as_user(user_context.username, command, args)
      end

      log "% #{command} #{args.join(' ')}\n\n" if options[:echo]

      pid, pipe = fork_and_exec(command, options[:env_vars], *args)
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

    def shell!(command, *args)
      result = shell(command, *args)
      raise "Shell command failed with status #{result.status}" if result.failed?
      result
    end

  private

    def fork_and_exec(command, env_vars, *args)
      read_end, write_end = IO.pipe
      pid = fork do
        read_end.close
        STDOUT.reopen(write_end)
        STDERR.reopen(write_end)
        env_vars.each { |key, value| ENV[key] = value }
        exec(command, *args.map(&:to_s))
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

    def command_as_user(user, command, args)
      args.unshift(command)
      command_str = [current_directory, current_umask, args.join(' ')].compact.join(' && ')
      ['su', ['-l', '-c', command_str, user]]
    end

    def current_directory
      if context = Tango::Contexts.context_for(:directory)
        "cd #{context.directory}"
      end
    end

    def current_umask
      if context = Tango::Contexts.context_for(:umask)
        "umask #{context.umask}"
      end
    end
  end
end

