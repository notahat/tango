require 'tango'

module Tango
  describe MetAndMeet do

    before do
      @stub = Class.new do
        include MetAndMeet

        def log(message); end
      end
    end

    it "should check the met?, run the meet, then check the met? again" do
      met_block_calls  = 0
      meet_block_calls = 0

      @stub.new.instance_eval do
        met? do
          met_block_calls += 1
          meet_block_calls > 0
        end
        meet { meet_block_calls += 1 }
      end

      met_block_calls.should  == 2
      meet_block_calls.should == 1
    end

    it "should not run the meet if the met? succeeds the first time" do
      met_block_calls  = 0
      meet_block_calls = 0

      @stub.new.instance_eval do
        met? do
          met_block_calls += 1
          true
        end
        meet { meet_block_calls += 1 }
      end

      met_block_calls.should  == 1
      meet_block_calls.should == 0
    end

    it "should raise if the met? block fails twice" do
      met_block_calls  = 0
      meet_block_calls = 0

      expect do
        @stub.new.instance_eval do
          met? do
            met_block_calls += 1
            false
          end
          meet { meet_block_calls += 1 }
        end
      end.should raise_error(CouldNotMeetError)

      met_block_calls.should  == 2
      meet_block_calls.should == 1
    end

    it "should raise an error if there's a meet block without a met block" do
      expect do
        @stub.new.instance_eval do
          meet { }
        end
      end.should raise_error(MeetWithoutMetError)
    end

  end
end

