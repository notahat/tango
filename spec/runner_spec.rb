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

      runner.new.run "example step"
      step_run.should be_true
    end

    it "should run one step from within another" do
      inner_step_run = false

      runner = Class.new(StubbedRunner) do
        step "outer step" do
          run "inner step"
        end

        step "inner step" do
          inner_step_run = true
        end
      end

      runner.new.run "outer step"
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

        runner.new.run "example step", 1, 2
      end

      it "should pass arguments when running other steps" do
        runner = Class.new(StubbedRunner) do
          step "outer step" do
            run "inner step", 1, 2
          end

          step "inner step" do |a, b|
            a.should == 1
            b.should == 2
          end
        end

        runner.new.run "outer step"
      end
    end

  end
end
