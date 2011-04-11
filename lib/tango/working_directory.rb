module Tango
  module WorkingDirectory

    def cd(directory)
      old_directory = Dir.getwd
      begin
        Dir.chdir(directory)
        yield
      ensure
        Dir.chdir(old_directory)
      end
    end

  end
end
