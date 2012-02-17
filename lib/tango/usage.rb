# coding: utf-8

require 'tango/version'

module Tango
  def self.print_usage
    puts <<-USAGE
Tango v#{Tango::VERSION}
usage: tango <ruby code to eval>
    USAGE
  end
end
