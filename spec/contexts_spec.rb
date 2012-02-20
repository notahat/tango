require 'tango'

module Tango
  describe Contexts do
    class Contexts::TestContext
      def enter; end
      def leave; end
    end

    let(:context) { Contexts::TestContext.new }

    it 'returns the context identified by the canonical name' do
      Contexts::Chain.new.in_context(context) do
        Contexts.context_for(:test_context).should == context
      end
    end

    it 'returns nil when not in the given context' do
      Contexts.context_for(:test_context).should be_nil
    end

    it 'finds the inner most context first' do
      outter_context = Contexts::TestContext.new
      Contexts::Chain.new.in_context(outter_context).in_context(context) do
        Contexts.context_for(:test_context).should == context
      end
    end
  end
end