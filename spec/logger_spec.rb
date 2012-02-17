# coding: utf-8

require 'tango'
require 'stringio'

module Tango
  describe Logger do

    before do
      @io = StringIO.new
      @logger = Logger.new(@io)
    end

    it "should output the step name when entering a step" do
      @logger.enter("example step")
      @io.string.should == "example step {\n"
    end

    it "should output a closing brace when leaving a step" do
      @logger.enter("example step")
      @logger.leave("example step")
      @io.string.should == "example step {\n} √ example step\n"
    end

    it "should indent nested steps" do
      @logger.enter("outer step")
      @logger.enter("inner step")
      @io.string.should == "outer step {\n  inner step {\n"
    end

  end
end
