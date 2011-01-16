require 'dep'

describe Dep do
  context "with just a meet block" do
    it "should run the meet block" do
      ran_the_meet_block = false
      dep = Dep.new do
        meet { ran_the_meet_block = true }
      end

      ran_the_meet_block.should be_false
      dep.run
      ran_the_meet_block.should be_true
    end
  end

  context "with a meet block and a met block" do
    it "should check the met?, run the meet, then check the met? again" do
      met_block_runs  = 0
      meet_block_runs = 0
      dep = Dep.new do
        met? do
          met_block_runs += 1
          meet_block_runs > 0
        end
        meet { meet_block_runs += 1 }
      end

      dep.run
      met_block_runs.should  == 2
      meet_block_runs.should == 1
    end

    it "should not run the meet if the met? succeeds the first time" do
      met_block_runs  = 0
      meet_block_runs = 0
      dep = Dep.new do
        met? do
          met_block_runs += 1
          true
        end
        meet { meet_block_runs += 1 }
      end

      dep.run
      met_block_runs.should == 1
      meet_block_runs.should == 0
    end

    it "should raise if the met? block fails twice" do
      met_block_runs  = 0
      meet_block_runs = 0
      dep = Dep.new do
        met? do
          met_block_runs += 1
          false
        end
        meet { meet_block_runs += 1 }
      end

      expect { dep.run }.should raise_error
      met_block_runs.should  == 2
      meet_block_runs.should == 1
    end
  end
end
