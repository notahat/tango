require 'tango'

module Tango
  describe DanceCard do

    it "should run a step in a dance by name" do
      step_run = false
      card = DanceCard.new
      card.dance "example dance" do
        step "example step" do
          step_run = true
        end
      end

      card.run "example dance:example step"

      step_run.should be_true
    end

    it "should pass arguments to a step" do
      card = DanceCard.new
      card.dance "example dance" do
        step "example step" do |a, b|
          a.should == 1
          b.should == 2
        end
      end

      card.run "example dance:example step", 1, 2
    end

    it "should call a step in another dance by name" do
      step_run = false

      card = DanceCard.new

      card.dance "foxtrot" do
        step "foxtrot step" do
          step_run = true
        end
      end

      card.dance "flamenco" do
        step "flamenco step" do
          run "foxtrot:foxtrot step"
        end
      end

      card.run "flamenco:flamenco step"

      step_run.should be_true
    end

  end
end

