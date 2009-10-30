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
end
