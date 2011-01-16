require 'step'

describe Step do
  context "with just a meet block" do
    it "should run the meet block" do
      meet_block_calls = 0
      step = Step.new do
        meet { meet_block_calls += 1 }
      end

      step.run
      meet_block_calls.should == 1
    end
  end

  context "with a meet block and a met block" do
    it "should check the met?, run the meet, then check the met? again" do
      met_block_calls  = 0
      meet_block_calls = 0
      step = Step.new do
        met? do
          met_block_calls += 1
          meet_block_calls > 0
        end
        meet { meet_block_calls += 1 }
      end

      step.run
      met_block_calls.should  == 2
      meet_block_calls.should == 1
    end

    it "should not run the meet if the met? succeeds the first time" do
      met_block_calls  = 0
      meet_block_calls = 0
      step = Step.new do
        met? do
          met_block_calls += 1
          true
        end
        meet { meet_block_calls += 1 }
      end

      step.run
      met_block_calls.should  == 1
      meet_block_calls.should == 0
    end

    it "should raise if the met? block fails twice" do
      met_block_calls  = 0
      meet_block_calls = 0
      step = Step.new do
        met? do
          met_block_calls += 1
          false
        end
        meet { meet_block_calls += 1 }
      end

      expect { step.run }.should raise_error
      met_block_calls.should  == 2
      meet_block_calls.should == 1
    end
  end

  context "run with options" do
    it "should pass the options to the met block" do
      step_options = { :example => "example" }

      step = Step.new do
        met? do |options|
          options.should == step_options
          true
        end
      end

      step.run(step_options)
    end

    it "should pass the options to the meet block" do
      step_options = { :example => "example" }

      step = Step.new do
        meet {|options| options.should == step_options }
      end

      step.run(step_options)
    end
  end

end
