require 'wordlist/version'

require 'spec_helper'

describe Wordlist do
  it "should have a VERSION constant" do
    Wordlist.const_defined?('VERSION').should == true
  end
end
