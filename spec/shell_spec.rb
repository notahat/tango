require 'tango'

module Tango
  describe Shell do

    before do
      @stub_class = Class.new do
        include Tango::Shell
        def log(message); end
        def log_raw(message); end
      end
    end

    it "should return the right info for a successful command" do
      result = @stub_class.new.shell("echo", "Hello, world!")
      result.output.should == "Hello, world!\n"
      result.status.should == 0
      result.succeeded?.should be_true
      result.failed?.should be_false
    end

    it "should return the right info for a failing command" do
      result = @stub_class.new.shell("test", "a", "=", "b")
      result.status.should == 1
      result.succeeded?.should be_false
      result.failed?.should be_true
    end

    it "should accept commands as a single argument" do
      result = @stub_class.new.shell("echo Hello, world!")
      result.output.should == "Hello, world!\n"
    end

    it "catches stderr too" do
      result = @stub_class.new.shell("echo 'Hello, world!' 1>&2")
      result.output.should == "Hello, world!\n"
    end

    it "should echo the command and its output" do
      @stub = @stub_class.new
      @stub.should_receive(:log).with("% echo Hello, world!\n\n").once.ordered
      @stub.should_receive(:log_raw).with("Hello, world!\n").once.ordered
      @stub.should_receive(:log).with("").once.ordered

      @stub.shell("echo", "Hello, world!")
    end

    it "should allow echo to be turned off" do
      @stub = @stub_class.new
      @stub.should_not_receive(:log)
      @stub.should_not_receive(:log_raw)

      @stub.shell("echo", "Hello, world!", :echo => false).output.should == "Hello, world!\n"
    end

    it "should export envionment variables" do
      @stub = @stub_class.new

      @stub.shell("env", :env_vars => {'SOMETHING' => 'some_value'}).output.should include('SOMETHING=some_value')
    end

    context "shell! method" do
      it "should raise an exception if the command fails" do
        expect {
          @stub_class.new.shell!("test", "a", "=", "b")
        }.should raise_error("Shell command failed with status 1")
      end
    end

    context 'as a user' do
      class Context
        def enter; end
        def leave; end
      end

      class User < Context
        def username; 'amy' end
      end

      class Directory < Context
        def directory; '/foo' end
      end

      class Umask < Context
        def umask; '0644' end
      end

      let(:user_context) { User.new }
      let(:dir_context) { Directory.new }
      let(:umask_context) { Umask.new }
      let(:klass) { @stub_class.new }
      let(:chain) { Contexts::Chain.new }

      before do
        klass.stub(:fork_and_exec => [0, stub(:pipe).as_null_object])
        klass.stub(:collect_output)
        Process.stub(:waitpid)
      end

      it 'executes the command in a new login shell' do
        klass.should_receive(:fork_and_exec).with('su', {}, '-l', '-c', "ls -al /dir", 'amy')
        chain.in_context(user_context) { klass.shell('ls', '-al', '/dir') }
      end

      it 'preserves the directory context' do
        klass.should_receive(:fork_and_exec).with('su', {}, '-l', '-c', "cd /foo && id", 'amy')
        chain.in_context(user_context).in_context(dir_context) { klass.shell('id') }
      end

      it 'preserves the umask context' do
        klass.should_receive(:fork_and_exec).with('su', {}, '-l', '-c', "umask 0644 && id", 'amy')
        chain.in_context(user_context).in_context(umask_context) { klass.shell('id') }
      end

      it 'preserves many contexts' do
        klass.should_receive(:fork_and_exec).with('su', {}, '-l', '-c', "cd /foo && umask 0644 && id", 'amy')
        chain.in_context(user_context).in_context(umask_context).in_context(dir_context) { klass.shell('id') }
      end
    end
  end
end
