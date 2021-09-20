require 'spec_helper'
require 'wordlist/modifiers/modifier'

describe Wordlist::Modifiers::Modifier do
  let(:wordlist) { %w[foo bar baz] }

  subject { described_class.new(wordlist) }

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
