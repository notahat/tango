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
end
