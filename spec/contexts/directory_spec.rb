require 'tango'

module Tango::Contexts
  describe Directory do
    
    before do
      stub_class = Class.new do
        include Helpers
      end
      @stub = stub_class.new

      # Make doubly sure we reset the working directory after each test.
      @original_directory = Dir.getwd
    end

    after do
      Dir.chdir(@original_directory)
    end

    it "should change the working directory" do
      directory = Dir.getwd + "/lib"
      @stub.in_directory(directory) do
        Dir.getwd.should == directory
      end
    end

    it "should restore the original working directory" do
      old_directory = Dir.getwd
      directory = Dir.getwd + "/lib"
      @stub.in_directory(directory) { }
      Dir.getwd.should == old_directory
    end

  end
end


