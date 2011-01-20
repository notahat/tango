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

    context "option passing" do
      it "should pass options to a step when running" do
        step_options = { :example => "example" }

        dance = Dance.new do
          step "example step" do |options|
            options.should == step_options
          end
        end

        dance.run "example step", step_options
      end

      it "should pass options when running other steps" do
        step_options = { :example => "example" }

        dance = Dance.new do
          step "outer step" do
            run "inner step", step_options
          end

          step "inner step" do |options|
            options.should == step_options
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
