require 'tango'

module Tango
  describe ConfigFiles do

    before do
      stub_class = Class.new do
        include ConfigFiles

        attr_accessor :world
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

    it "should unindent contents before writing" do
      @stub.write("tmp/example.conf", <<-EOF)
        Goodbye
          cruel
        world!
      EOF
      File.read("tmp/example.conf").should == "Goodbye\n  cruel\nworld!\n"
    end

    it 'does not unindent contents read from an File' do
      File.open('tmp/template', 'w') do |fd|
        fd.write('    England!')
      end
      @stub.write('tmp/example.conf', File.open('tmp/template', 'r'))
      File.read('tmp/example.conf').should == '    England!'
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

    it 'opens an ERB template relative to the runner file' do
      tmp = File.join(File.dirname(__FILE__), '../tmp')
      caller_path = File.join(tmp, 'runner.rb')
      @stub.should_receive(:caller).and_return(["#{caller_path}:80:in `your face'"])
      FileUtils.touch(File.join(tmp, 'config.sh.erb'))
      @stub.template('config.sh.erb').path.should == File.join(File.dirname(caller_path), 'config.sh.erb')
    end
  end
end
