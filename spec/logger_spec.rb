# coding: utf-8

require 'tango'
require 'stringio'

module Tango
  describe Logger do

    before do
      @io = StringIO.new
      @logger = Logger.new(@io)
    end

    it "should output the step name when beginning a step" do
      @logger.begin_step("example step")
      @io.string.should == "example step {\n"
    end

    it "should output a closing brace when a step is met" do
      @logger.begin_step("example step")
      @logger.step_met("example step")
      @io.string.should == "example step {\n} √ example step\n"
    end

    it "should output a closing brace when a step is not met" do
      @logger.begin_step("example step")
      @logger.step_not_met("example step")
      @io.string.should == "example step {\n} ✕ example step\n\n"
    end

    it "should indent nested steps" do
      @logger.begin_step("outer step")
      @logger.begin_step("inner step")
      @io.string.should == "outer step {\n  inner step {\n"
    end

    it "should accept a few colours" do
      @logger.should_receive(:red)
      @logger.log("hello", :red)

      @logger.should_receive(:yellow)
      @logger.log("hello", :yellow)

      @logger.should_receive(:green)
      @logger.log("hello", :green)
    end

    it "should ignore other colours" do
      @logger.should_not_receive(:brown)
      @logger.log("hello", :brown)
    end
  end
end
