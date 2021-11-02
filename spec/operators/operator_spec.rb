require 'spec_helper'
require 'wordlist/operators/operator'

describe Wordlist::Operators::Operator do
  it do
    expect(described_class).to include(Enumerable)
  end

  describe "#each" do
    it do
      expect {
        subject.each
      }.to raise_error(NotImplementedError,"#{described_class}#each was not implemented")
    end
  end
end
