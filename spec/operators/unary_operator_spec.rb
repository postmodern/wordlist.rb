require 'spec_helper'
require 'wordlist/operators/unary_operator'

describe Wordlist::Operators::UnaryOperator do
  let(:wordlist) { %w[foo bar] }

  subject { described_class.new(wordlist) }

  describe "#initialize" do
    it "must set #wordlist" do
      expect(subject.wordlist).to eq(wordlist)
    end
  end
end
