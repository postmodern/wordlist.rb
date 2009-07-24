require 'wordlist/builder'

require 'spec_helper'
require 'helpers/text'
require 'builder_examples'

require 'tempfile'
require 'fileutils'

describe Builder do
  describe "new wordlist" do
    before(:all) do
      @expected = ['dog', 'cat', 'catx', 'dat']
    end

    before(:each) do
      @path = Tempfile.new('wordlist').path
    end

    it_should_behave_like "a wordlist Builder"
  end

  describe "existing wordlist" do
    before(:all) do
      @path = '/tmp/bla'
      @expected = ['dog', 'cat', 'log', 'catx', 'dat']
    end

    before(:each) do
      @path = Tempfile.new('wordlist').path
      FileUtils.cp(PREVIOUS_WORDLIST,@path)
    end

    it_should_behave_like "a wordlist Builder"
  end
end
