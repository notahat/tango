require 'tango/met_and_meet'

module Tango
  # A step's block is instance_execed against one of these. It provides all the
  # methods accessible from within the step.
  class StepRunner
    include MetAndMeet

    def initialize(context = nil)
      @context = context
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

    def log(message)
      @context.log(message) unless @context.nil?
    end

  end
end
