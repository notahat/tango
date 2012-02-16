require 'tango'

class StubbedLogger
  def enter(name); end
  def leave(name); end
  def log(message); end
end

class StubbedRunner < Tango::Runner
  def logger
    @logger ||= StubbedLogger.new
  end
end

module Tango
  describe Runner do

    it "should run a step" do
      step_run = false

      runner = Class.new(StubbedRunner) do
        step "example step" do
          step_run = true
        end
      end

      runner.new.send "example step"
      step_run.should be_true
    end

    it "should run one step from within another" do
      inner_step_run = false

      runner = Class.new(StubbedRunner) do
        step "outer step" do
          send "inner step"
        end

        step "inner step" do
          inner_step_run = true
        end
      end

      runner.new.send "outer step"
      inner_step_run.should be_true
    end

    context "passing arguments" do
      it "should pass arguments to a step" do
        runner = Class.new(StubbedRunner) do
          step "example step" do |a, b|
            a.should == 1
            b.should == 2
          end
        end

        runner.new.send "example step", 1, 2
      end

      it "should pass arguments when running other steps" do
        runner = Class.new(StubbedRunner) do
          step "outer step" do
            send "inner step", 1, 2
          end

          step "inner step" do |a, b|
            a.should == 1
            b.should == 2
          end
        end

        runner.new.send "outer step"
      end
    end

    describe 'perform' do
      class PerformRunner < StubbedRunner
        def history
          @history ||= []
        end

        step :first do
          history << :first
        end

        step :last do
          history << :last
        end
      end

      it 'passes the args to the constructor' do
        arg = stub
        runner = PerformRunner.new
        PerformRunner.should_receive(:new).with(arg).and_return(runner)
        PerformRunner.perform(arg)
      end

      it 'performs steps in the order they were defined' do
        runner = PerformRunner.new
        PerformRunner.stub(:new => runner)
        PerformRunner.perform
        runner.history.should == [:first, :last]
      end
    end
  end
end
