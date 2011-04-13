require 'tango'

module Tango::Contexts
  describe Directory do
    
    before do
      stub_class = Class.new do
        include Tango::Contexts
      end
      @stub = stub_class.new

      # Make doubly sure we reset the working directory after each test.
      @original_directory = Dir.getwd
    end

    after do
      Dir.chdir(@original_directory)
    end

    it "should run a block" do
      block_run = false
      @stub.in_directory("/tmp") { block_run = true }
      block_run.should be_true
    end

    it "should return the return value of the block" do
      result = @stub.in_directory("/tmp") { "I woz ere." }
      result.should == "I woz ere."
    end

    it "should change directory" do
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

    it "should restore the original directory after an exception" do
      old_directory = Dir.getwd
      directory = Dir.getwd + "/lib"
      expect {
        @stub.in_directory(directory) { raise "Uh oh!" }
      }.should raise_error
      Dir.getwd.should == old_directory
    end

  end
end


