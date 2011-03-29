module Tango
  module AsUser

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
