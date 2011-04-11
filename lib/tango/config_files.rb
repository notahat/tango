module Tango
  module ConfigFiles

    def write(path, contents)
      File.open(path, "w") do |file|
        file.write(unindent(contents))
      end
    end

  private

    def unindent(text)
      indent = /^ */.match(text)
      text.gsub(/^#{indent}/, "")
    end

  end
end
