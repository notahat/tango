module Tango
  module Contexts
    class User

      def initialize(username)
        @username = username
      end

      def enter
        @uid, @gid = Process.euid, Process.egid
        Process::Sys.seteuid(0) if @uid != 0
        info = Etc.getpwnam(@username)
        Process::Sys.setegid(info.gid)
        Process::Sys.seteuid(info.uid)
      end

      def exit
        Process::Sys.seteuid(@uid)
        Process::Sys.setegid(@gid)
      end

    end
  end
end
