require 'tango'

module Tango::Contexts
  describe Chain do

    before do
      @context_class = Class.new do
        def in_context?
          @in_context
        end

        def initialize
          @in_context = false
        end

        def enter 
          @in_context = true
        end

        def leave
          @in_context = false
        end
      end

      @context = @context_class.new
    end

    it "should run a block" do
      block_run = false
      Chain.new.in_context(@context) { block_run = true }
      block_run.should be_true
    end

    it "should return the return value of the block" do
      result = Chain.new.in_context(@context) { "I woz ere." }
      result.should == "I woz ere."
    end

    it "should run the context's enter method before the block" do
      Chain.new.in_context(@context) do
        @context.should be_in_context
      end
    end

    it "should run the context's leave method after leaving the block" do
      Chain.new.in_context(@context) { }
      @context.should_not be_in_context
    end

    it "should run the context's leave method on an exception" do
      expect {
        Chain.new.in_context(@context) { raise "Uh oh" }
      }.should raise_error("Uh oh")
      @context.should_not be_in_context
    end

    describe "when chaining contexts" do
      before do
        @a = @context_class.new
        @b = @context_class.new
      end

      it "should run the enter method of each context" do
        Chain.new.in_context(@a).in_context(@b) do
          @a.should be_in_context
          @b.should be_in_context
        end
      end

      it "should run the leave method of each context" do
        Chain.new.in_context(@a).in_context(@b) { }
        @a.should_not be_in_context
        @b.should_not be_in_context
      end
    end

  end
end
