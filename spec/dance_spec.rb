require 'dance'

describe Dance do

  it "should run a step" do
    step_run = false

    dance = Dance.new do
      step "example step" do
        meet { step_run = true }
      end
    end

    dance.run "example step"
    step_run.should be_true
  end

  # it "should let you run one step from within another" do
  #   inner_step_run = false

  #   dance = Dance.new do
  #     step "inner step" do
  #       meet { inner_step_run = true }
  #     end

  #     step "outer step" do
  #       meet { run "inner step" }
  #     end
  #   end

  #   dance.run "outer step"
  #   inner_step_run.should be_true
  # end

  it "should raise an error on an attempt to redefine a step"
  it "should raise an error on an attempt to run an undefined step"
end
