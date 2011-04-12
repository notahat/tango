require 'erb'
require 'fileutils'

module Tango
  module ConfigFiles

    def write(path, contents, permissions = nil)
      contents = unindent(contents)
      contents = ERB.new(contents).result(binding)
      File.open(path, "w") {|file| file.write(contents) }
      FileUtils.chmod(permissions, path) if permissions
    end

  private

    def unindent(text)
      indent = /^ */.match(text)
      text.gsub(/^#{indent}/, "")
    end

  end
end
