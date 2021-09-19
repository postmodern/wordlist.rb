require 'spec_helper'
require 'wordlist/operators/power'

describe Wordlist::Operators::Power do
  let(:wordlist)  { %w[foo bar] }
  let(:exponent)  { 3 }

  subject { described_class.new(wordlist,exponent) }

  let(:expected_words) do
    %w[
      foofoofoo
      foofoobar
      foobarfoo
      foobarbar
      barfoofoo
      barfoobar
      barbarfoo
      barbarbar
    ]
  end

  describe "#initialize" do
    it "must set #wordlist to a #{Operators::Product} object" do
      expect(subject.wordlists).to be_kind_of(Operators::Product)
      expect(subject.wordlists.left).to eq(wordlist)
      expect(subject.wordlists.right).to be_kind_of(Operators::Product)
      expect(subject.wordlists.right.left).to eq(wordlist)
      expect(subject.wordlists.right.right).to eq(wordlist)
    end

    context "when the exponent is 1" do
      let(:exponent) { 1 }

      it "must set #wordlists to the given wordlist" do
        expect(subject.wordlists).to eq(wordlist)
      end
    end
  end

  describe "#each" do
    context "when given a block" do
      it "must yield words from the left-hand wordlist with the right-hand" do
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args(*expected_words)
      end
    end

    context "when not given a block" do
      it "must return an Enumerator for the #each" do
        expect(subject.each).to be_kind_of(Enumerator)
        expect(subject.each.to_a).to eq(expected_words)
      end
    end
  end
end
