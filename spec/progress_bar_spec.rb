# encoding: utf-8

require 'tango'

describe Tango::ProgressBar do
  class Tango::ProgressBar
    def green(str); str end
  end

  let(:logger) { stub(:depth => 0) }
  let(:runner) { stub(:progress => 100, :logger => logger, :log_raw => nil) }
  subject { Tango::ProgressBar.show(runner) { } }

  it 'ensures the runner implements the progress method' do
    expect do
      Tango::ProgressBar.show(stub) { }
    end.should raise_error(Tango::MustImplementProgressMethodError)
  end

  it 'calls the given block' do
    @called = false
    block = lambda { @called = true }
    Tango::ProgressBar.show(runner, &block)
    @called.should be_true
  end

  it 'logs the progress' do
    runner.stub(:progress => 50)
    runner.should_receive(:log_raw).with(' |❚❚❚❚❚❚❚❚❚❚❚❚❚❚❚❚❚❚❚❚                    | 50%')
    Tango::ProgressBar.show(runner) { }
  end

  it 'clears the progress bar when complete' do
    runner.stub(:progress => 100)
    runner.should_receive(:log_raw).with("\b \b" * (48 * 3))
    Tango::ProgressBar.show(runner) { }
  end
end
