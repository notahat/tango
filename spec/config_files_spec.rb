require 'derp'

module Derp
  describe ConfigFiles do

    before do
      stub_class = Class.new do
        include ConfigFiles

        attr_accessor :world
      end
      @stub = stub_class.new

      # Make the tmp directory if it doesn't exist.
      Dir.mkdir("tmp") unless File.exist?("tmp")

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

    it "should unindent contents before writing" do
      @stub.write("tmp/example.conf", <<-EOF)
        Goodbye
          cruel
        world!
      EOF
      File.read("tmp/example.conf").should == "Goodbye\n  cruel\nworld!\n"
    end

    it "should render ERB in the contents" do
      @stub.write("tmp/example.conf", "Hello, <%= 'world!' %>")
      File.read("tmp/example.conf").should == "Hello, world!"
    end

    it "should allow access to instance variables in the ERB" do
      @stub.world = "world!"
      @stub.write("tmp/example.conf", "Hello, <%= @world %>")
      File.read("tmp/example.conf").should == "Hello, world!"
    end
    
  end
end
