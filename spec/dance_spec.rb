require 'tango'

module Tango
  describe Dance do

    it "should run a step" do
      step_run = false

      dance = Dance.new do
        step "example step" do
          step_run = true
        end
      end

      dance.run "example step"
      step_run.should be_true
    end

    it "should run one step from within another" do
      inner_step_run = false

      dance = Dance.new do
        step "outer step" do
          run "inner step"
        end

        step "inner step" do
          inner_step_run = true
        end
      end

      dance.run "outer step"
      inner_step_run.should be_true
    end

    context "passing arguments" do
      it "should pass arguments to a step" do
        dance = Dance.new do
          step "example step" do |a, b|
            a.should == 1
            b.should == 2
          end
        end

        dance.run "example step", 1, 2
      end

      it "should pass arguments when running other steps" do
        dance = Dance.new do
          step "outer step" do
            run "inner step", 1, 2
          end

          step "inner step" do |a, b|
            a.should == 1
            b.should == 2
          end
        end

        dance.run "outer step"
      end
    end

    context "error handling" do
      it "should raise an error on an attempt to redefine a step" do
        expect do
          Dance.new do
            step "example step" do; end
            step "example step" do; end
          end
        end.should raise_error(Dance::StepAlreadyDefinedError)
      end

      it "should raise an error on an attempt to run an undefined step" do
        dance = Dance.new do; end

        expect do
          dance.run "undefined step"
        end.should raise_error(Dance::UndefinedStepError)
      end
    end

  end
end
