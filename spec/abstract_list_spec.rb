require 'spec_helper'
require 'wordlist/abstract_wordlist'

describe Wordlist::AbstractWordlist do
  it do
    expect(described_class).to include(Enumerable)
  end

  it do
    expect(described_class).to include(Wordlist::ListMethods)
  end

  describe "#each" do
    it do
      expect { subject.each }.to raise_error(NotImplementedError,"#{described_class}#each was not implemented")
    end
  end
end
