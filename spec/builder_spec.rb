require 'wordlist/builder'

require 'spec_helper'
require 'tempfile'
require 'fileutils'

describe Builder do
  describe "new wordlist" do
    before(:each) do
      @path = Tempfile.new.path
    end

    it "should build a unique wordlist from a sentence" do
    end

    it "should build a unique wordlist from text" do
    end

    it "should build a unique wordlist from a file" do
    end
  end

  describe "existing wordlist" do
  end
end
