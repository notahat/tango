# coding: utf-8

require 'tango'

module Tango
  describe Shell do

    before do
      @stub_class = Class.new do
        include Tango::Shell
        def log(message); end
        def log_raw(message); end
      end
    end

    it "should return the right info for a successful command" do
      result = @stub_class.new.shell("echo", "Hello, world!")
      result.output.should == "Hello, world!\n"
      result.status.should == 0
      result.succeeded?.should be_true
      result.failed?.should be_false
    end

    it "should return the right info for a failing command" do
      result = @stub_class.new.shell("test", "a", "=", "b")
      result.status.should == 1
      result.succeeded?.should be_false
      result.failed?.should be_true
    end

    it "should accept commands as a single argument" do
      result = @stub_class.new.shell("echo Hello, world!")
      result.output.should == "Hello, world!\n"
    end

    it "catches stderr too" do
      result = @stub_class.new.shell("echo 'Hello, world!' 1>&2")
      result.output.should == "Hello, world!\n"
    end

    it "should echo the command and its output" do
      @stub = @stub_class.new
      @stub.should_receive(:log).with("% echo Hello, world!\n\n").once.ordered
      @stub.should_receive(:log_raw).with("Hello, world!\n").once.ordered
      @stub.should_receive(:log).with("").once.ordered

      @stub.shell("echo", "Hello, world!")
    end

    it "should allow echo to be turned off" do
      @stub = @stub_class.new
      @stub.should_not_receive(:log)
      @stub.should_not_receive(:log_raw)

      @stub.shell("echo", "Hello, world!", :echo => false).output.should == "Hello, world!\n"
    end

    it "should export envionment variables" do
      @stub = @stub_class.new

      @stub.shell("env", :env_vars => {'SOMETHING' => 'some_value'}).output.should include('SOMETHING=some_value')
    end

    context "shell! method" do
      it "should raise an exception if the command fails" do
        expect {
          @stub_class.new.shell!("test", "a", "=", "b")
        }.should raise_error("Shell command failed with status 1")
      end
    end

  end
end
