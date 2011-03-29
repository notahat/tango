module Tango
  # A step's block is instance_execed against one of these. It provides all the
  # methods accessible from within the step.
  class StepRunner

    def initialize(context = nil)
      @context = context
    end

    def met?(&met_block)
      @met_block = met_block
    end

    def meet(&meet_block)
      raise MeetWithoutMetError if @met_block.nil?
      unless instance_eval(&@met_block)
        instance_eval(&meet_block)
        raise CouldNotMeetError unless instance_eval(&@met_block)
      end
    end

    def run(step_name, *args)
      @context.run(step_name, *args)
    end

    def as(username)
      info = Etc.getpwent(username)
      uid, gid = Process.euid, Process.egid
      Process::Sys.seteuid(0) if uid != 0
      Process::Sys.setegid(info.gid)
      Process::Sys.seteuid(info.uid)
      yield
    ensure
      Process::Sys.seteuid(uid)
      Process::Sys.setegid(gid)
    end

  end
end
