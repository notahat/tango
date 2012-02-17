# coding: utf-8

require 'tango'

module Tango::Helpers
  describe FileManipulationHelpers do
    include FileManipulationHelpers
    include ::Tango::ConfigFiles

    describe "#grep" do
      before do
        @filename = '/tmp/file_manipulation_helper_spec.txt'
        File.open(@filename, 'w') do |f|
          f.write <<-FILE
anna
bob
curtis
donald
          FILE
        end
      end

      it 'should return true if the pattern matches' do
        grep(/bob/, @filename).should be_true
      end
      it 'should return false if the pattern doesnt match' do
        grep(/robert/, @filename).should be_false
      end
    end

    describe "#change_line" do

      def file_contents
        File.read(@filename)
      end

      before do
        @filename = '/tmp/file_manipulation_helper_spec.txt'
        File.open(@filename, 'w') do |f|
          f.write <<-FILE
anna
bob
curtis
donald
          FILE
        end
      end

      it 'should replace the line matching the regex with the specified line' do
        expect {
          change_line(/^bob/, "jimbo", @filename)
        }.to change {
          #ignore comment
          file_contents.gsub /#.*\n/, ''
        }.to(<<-FILE)
anna
jimbo
curtis
donald
FILE
      end
    end

    describe "#insert_into_file" do
      def file_contents
        File.read(@filename)
      end

      before do
        @filename = '/tmp/file_manipulation_helper_spec.txt'
        File.open(@filename, 'w') do |f|
          f.write <<-FILE
a
b
c
d
          FILE
        end
      end

      it 'should insert a comment above the inserted line' do
        insert_into_file('c', @filename, "z\n")
        file_contents.should =~ /# Envato config added.*\nz\n/
      end

      it 'should insert text before the specified place' do
        expect {
          insert_into_file('c', @filename, "z\n")
        }.to change {
          #ignore comment
          file_contents.gsub /#.*\n/, ''
        }.to(<<-FILE)
a
b
z
c
d
        FILE
      end
    end

    describe "#cut" do

      let(:data) { %w[a b c d] }

      it "should cut the lines into two" do
        cut(data, 'c').should == [%w[a b], %w[c d]]
      end

      it "should ignore whitespace around the string to cut on" do
        cut(data, '    c     ').should == [%w[a b], %w[c d]]
      end

      it "should cut the lines into two" do
        data = ['a', 'b', '    c    ', 'd']
        cut(data, 'c').should == [%w[a b], ['    c    ', 'd']]
      end

      it 'should raise an error if the cut-point cant be found' do
        expect {
          cut(data, 'z')
        }.to raise_error
      end
    end

    describe "#change_config_attribute" do

      def file_contents
        File.read(@filename)
      end

      before do
        @filename = '/tmp/file_manipulation_helper_spec.txt'
        File.open(@filename, 'w') do |f|
          f.write <<-FILE
AwesomeStuff false
NotAwesomeStuff true
          FILE
        end
      end

      it "should replace the incorrect setting if it's there" do
        expect {
          change_config_attribute('AwesomeStuff', 'false', 'true', @filename)
        }.to change {
          file_contents
        }.to(<<-FILE)
NotAwesomeStuff true
AwesomeStuff true
        FILE
      end

      it "should add the correct setting if it is unconfigured" do
        expect {
          change_config_attribute('OtherAwesomeStuff', 'false', 'true', @filename)
        }.to change {
          file_contents
        }.to(<<-FILE)
AwesomeStuff false
NotAwesomeStuff true
OtherAwesomeStuff true
        FILE
      end
      it "should leave the correct setting alone" do
        expect {
          change_config_attribute('AwesomeStuff', 'true', 'false', @filename)
        }.to_not change {
          file_contents
        }
      end
    end
  end
end
