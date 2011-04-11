require 'erb'

module Tango
  module ConfigFiles

    def write(path, contents)
      contents = unindent(contents)
      contents = ERB.new(contents).result(binding)
      File.open(path, "w") {|file| file.write(contents) }
    end

  private

    def unindent(text)
      indent = /^ */.match(text)
      text.gsub(/^#{indent}/, "")
    end

  end
end
