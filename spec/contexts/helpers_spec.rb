require 'tango'

describe 'home_dir' do
  class RunnerDouble
    include Tango::Contexts::Helpers
  end

  subject { RunnerDouble.new }

  before do
    Process.stub(:euid => 1)
    Etc.stub(:getpwuid => stub(:dir => '/home/pete-o'))
  end

  it 'uses EUID to identify the current user' do
    Process.should_receive(:euid)
    subject.home_dir
  end

  it 'reads the passwd line for the user' do
    Etc.should_receive(:getpwuid).with(1)
    subject.home_dir
  end

  it 'returns the home directory' do
    subject.home_dir.should == '/home/pete-o'
  end
end
