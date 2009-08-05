require 'spec_helper'
require 'helpers/text'
require 'helpers/wordlist'

shared_examples_for "a wordlist Builder" do
  before(:all) do
    @words = ['dog', 'cat', 'catx', 'dat', 'dog', 'cat']
    @sentence = 'dog cat catx, dog dat.'
    @text = 'dog cat: catx. dog cat dat dog.'
    @file = SAMPLE_TEXT
  end

  it "should build a unique wordlist from words" do
    Builder.build(@path) do |wordlist|
      wordlist += @words
    end

    should_contain_words(@path,@expected)
  end

  it "should build a unique wordlist from a sentence" do
    Builder.build(@path) do |wordlist|
      wordlist.parse(@sentence)
    end

    should_contain_words(@path,@expected)
  end

  it "should build a unique wordlist from text" do
    Builder.build(@path) do |wordlist|
      wordlist.parse(@text)
    end

    should_contain_words(@path,@expected)
  end

  it "should build a unique wordlist from a file" do
    Builder.build(@path) do |wordlist|
      wordlist.parse_file(@file)
    end

    should_contain_words(@path,@expected)
  end
end
