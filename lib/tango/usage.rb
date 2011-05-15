require 'tango/version'

module Tango
  def self.print_usage
    puts <<-USAGE
Tango v#{Tango::VERSION}
usage: tango step_file.rb ClassName.step_name
    USAGE
  end
end
