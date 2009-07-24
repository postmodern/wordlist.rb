require 'wordlist/unique_filter'

require 'spec_helper'

describe UniqueFilter do
  before(:each) do
    @filter = UniqueFilter.new
  end

  it "should have seen words" do
    @filter.saw!('cat')

    @filter.seen?('cat').should == true
    @filter.seen?('dog').should == false
  end

  it "should only see a unique word once" do
    @filter.saw!('cat').should == true
    @filter.saw!('cat').should == false
  end

  it "should pass only unique words through the filter" do
    input = ['dog', 'cat', 'dog']
    output = []

    input.each do |word|
      @filter.pass(word) do |result|
        output << result
      end
    end

    output.should == ['dog', 'cat']
  end
end
