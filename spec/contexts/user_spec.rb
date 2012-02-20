require 'tango'

module Tango::Contexts
  describe User do
    it 'exposes the username' do
      User.new('amy').username.should == 'amy'
    end
  end
end