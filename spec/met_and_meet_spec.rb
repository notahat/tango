require 'tango'

module Tango
  describe MetAndMeet do

    let(:runner) do
      Class.new do
        include MetAndMeet
      end.new
    end

    before { runner.stub(:log => nil) }

    it "should check the met?, run the meet, then check the met? again" do
      met_block_calls  = 0
      meet_block_calls = 0

      runner.instance_eval do
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

      runner.instance_eval do
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
        runner.instance_eval do
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
        runner.instance_eval do
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

    describe 'met! with meet' do
      it 'raise an error if a met! block is met before meet is called' do
        expect do
          runner.instance_eval do
            met! { true }
            meet { }
          end
        end.should raise_error(MustNotMeetError)
      end

      it 'does not raise an error if a met! block is met after meet is called' do
        expect do
          runner.instance_eval do
            @met = false
            met! { @met }
            meet { @met = true }
          end
        end.should_not raise_error(MustNotMeetError)
      end

      it 'raises an error if the met! block is not met after meet is called' do
        expect do
          runner.instance_eval do
            met! { false }
            meet {  }
          end
        end.should raise_error(CouldNotMeetError)
      end

      it 'logs that the met! has not already been met' do
        runner.should_receive(:log).with('not already met.')
        runner.instance_eval do
          @met = false
          met! { @met }
          meet { @met = true }
        end
      end

      it 'logs when the block is met' do
        runner.should_receive(:log).with('met.')
        runner.instance_eval do
          @met = false
          met! { @met }
          meet { @met = true }
        end
      end
    end
  end
end