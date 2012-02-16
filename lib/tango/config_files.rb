require 'erb'
require 'fileutils'

module Tango
  module ConfigFiles

    def write(path, contents, permissions = nil)
      contents = contents.is_a?(File) ? contents.read : unindent(contents)
      contents = ERB.new(contents).result(binding)
      File.open(path, "w") {|file| file.write(contents) }
      FileUtils.chmod(permissions, path) if permissions
    end

    def template(path)
      caller_file = caller.first.split(':').first
      File.open(File.join(File.dirname(caller_file), path), 'r')
    end

  private

    def unindent(text)
      indent = /^ */.match(text)
      text.gsub(/^#{indent}/, "")
    end
  end
end
