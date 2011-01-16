require 'dep'

describe Dep do
  context "with just a meet block" do
    it "should run the meet block" do
      meet_block_calls = 0
      dep = Dep.new do
        meet { meet_block_calls += 1 }
      end

      dep.run
      meet_block_calls.should == 1
    end
  end

  context "with a meet block and a met block" do
    it "should check the met?, run the meet, then check the met? again" do
      met_block_calls  = 0
      meet_block_calls = 0
      dep = Dep.new do
        met? do
          met_block_calls += 1
          meet_block_calls > 0
        end
        meet { meet_block_calls += 1 }
      end

      dep.run
      met_block_calls.should  == 2
      meet_block_calls.should == 1
    end

    it "should not run the meet if the met? succeeds the first time" do
      met_block_calls  = 0
      meet_block_calls = 0
      dep = Dep.new do
        met? do
          met_block_calls += 1
          true
        end
        meet { meet_block_calls += 1 }
      end

      dep.run
      met_block_calls.should  == 1
      meet_block_calls.should == 0
    end

    it "should raise if the met? block fails twice" do
      met_block_calls  = 0
      meet_block_calls = 0
      dep = Dep.new do
        met? do
          met_block_calls += 1
          false
        end
        meet { meet_block_calls += 1 }
      end

      expect { dep.run }.should raise_error
      met_block_calls.should  == 2
      meet_block_calls.should == 1
    end
  end
end
