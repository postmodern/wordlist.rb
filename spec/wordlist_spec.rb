require 'spec_helper'
require 'wordlist/version'

describe Wordlist do
  it "should have a VERSION constant" do
    expect(Wordlist.const_defined?('VERSION')).to be(true)
  end
end
