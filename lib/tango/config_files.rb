module Tango
  module ConfigFiles

    def write(path, contents)
      File.open(path, "w") do |file|
        file.write(contents)
      end
    end

  end
end
