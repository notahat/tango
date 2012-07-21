# coding: utf-8

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

    it "should not have met blocks trample on one another" do
      klass = Class.new do
        include MetAndMeet

        def log(message); end

        def a
          met? { false }
          meet { b }
        end

        def b
          met? { true }
          meet { }
        end
      end

      expect { klass.new.a }.should raise_error(CouldNotMeetError)
    end

    context "with TANGO_DRY_RUN set" do
      before do
        ENV['TANGO_DRY_RUN'] = 'true'
      end

      it "should not execute meet blocks if met passes" do
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

      it "should not execute meet blocks if met fails" do
        met_block_calls  = 0
        meet_block_calls = 0

        @stub.new.instance_eval do
          met? do
            met_block_calls += 1
            false
          end
          meet { meet_block_calls += 1 }
        end

        met_block_calls.should  == 1
        meet_block_calls.should == 0
      end
    end
  end
end

