require 'spec_helper'
require 'wordlist/version'

describe Wordlist do
  it "should have a VERSION constant" do
    Wordlist.const_defined?('VERSION').should == true
  end
end
