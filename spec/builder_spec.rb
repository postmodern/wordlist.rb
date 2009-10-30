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
end
