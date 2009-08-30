require 'wordlist/formats/flat_file'

require 'spec_helper'

describe Formats::FlatFile do
  before(:all) do
    @path = File.join(File.dirname(__FILE__),'files','flat_file.txt')
    @list = Formats::FlatFile.new(@path)
  end

  it "should have a path it reads from" do
    @list.path.should == @path
  end

  it "should read the lines of the flat-file" do
    words = ['one', 'two', 'three']

    @list.each_word do |word|
      words.include?(word).should == true
      words.delete(word)
    end

    words.should == []
  end
end
