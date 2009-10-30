require 'wordlist/builder'

require 'spec_helper'
require 'helpers/text'
require 'helpers/wordlist'
require 'builder_examples'

describe Builder do
  include Helpers

  describe "new wordlist" do
    before(:all) do
      @expected = ['dog', 'cat', 'catx', 'dat']
    end

    before(:each) do
      @path = wordlist_tempfile
    end

    it_should_behave_like "a wordlist Builder"
  end

  describe "existing wordlist" do
    before(:all) do
      @path = '/tmp/bla'
      @expected = ['dog', 'cat', 'log', 'catx', 'dat']
    end

    before(:each) do
      @path = wordlist_tempfile(Helpers::PREVIOUS_WORDLIST)
    end

    it_should_behave_like "a wordlist Builder"
  end

  describe "word queue" do
    before(:all) do
      @path = wordlist_tempfile
    end

    before(:each) do
      @builder = Builder.new(@path, :max_words => 2)
    end

    it "should act like a queue" do
      @builder.enqueue('dog')
      @builder.enqueue('cat')

      @builder.word_queue.should == ['dog', 'cat']
    end

    it "should have a maximum length of the queue" do
      @builder.enqueue('dog')
      @builder.enqueue('cat')
      @builder.enqueue('log')

      @builder.word_queue.should == ['cat', 'log']
    end
  end

  describe "word combinations" do
    before(:all) do
      @path = wordlist_tempfile
    end

    it "should yield only one word when max_words is set to 1" do
      builder = Builder.new(@path)
      builder.enqueue('dog')

      builder.word_combinations do |words|
        words.should == 'dog'
      end
    end

    it "should include the last seen word in every combination" do
      builder = Builder.new(@path, :max_words => 2)
      builder.enqueue('dog')
      builder.enqueue('cat')
      builder.enqueue('dat')

      builder.word_combinations do |words|
        words.split(' ').include?('dat').should == true
      end
    end

    it "should include a minimum number of words" do
      builder = Builder.new(@path, :min_words => 2, :max_words => 3)
      builder.enqueue('dog')
      builder.enqueue('cat')
      builder.enqueue('dat')

      builder.word_combinations do |words|
        words.split(' ').length.should >= 2
      end
    end

    it "should not include more than a maximum number of words" do
      builder = Builder.new(@path, :max_words => 2)
      builder.enqueue('dog')
      builder.enqueue('cat')
      builder.enqueue('dat')

      builder.word_combinations do |words|
        words.split(' ').length.should_not > 2
      end
    end

    it "should preserve the order words were seen in" do
      builder = Builder.new(@path, :max_words => 3)
      builder.enqueue('dog')
      builder.enqueue('cat')
      builder.enqueue('dat')

      combinations = []

      builder.word_combinations do |words|
        combinations << words
      end

      combinations.should == [
        ['dat'],
        ['cat dat'],
        ['dog cat dat']
      ]
    end
  end
end
