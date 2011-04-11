require 'tango'

module Tango
  describe ConfigFiles do

    before do
      stub_class = Class.new do
        include ConfigFiles
      end
      @stub = stub_class.new

      # Clear out the tmp directory before each test.
      Dir.glob("tmp/*").each {|path| File.delete(path) }
    end

    it "should write a file" do
      @stub.write("tmp/example.conf", "Hello, world!")
      File.should exist("tmp/example.conf")
      File.read("tmp/example.conf").should == "Hello, world!"
    end

    it "should overwrite an existing file" do
      FileUtils.touch("tmp/example.conf")
      @stub.write("tmp/example.conf", "Hello, world!")
      File.read("tmp/example.conf").should == "Hello, world!"
    end
    
  end
end
