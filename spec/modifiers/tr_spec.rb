require 'spec_helper'
require 'wordlist/modifiers/tr'

describe Wordlist::Modifiers::Tr do
  let(:wordlist) { %w[foo bar baz] }

  let(:chars)   { 'oa' }
  let(:replace) { '0@' }

  subject { described_class.new(wordlist,chars,replace) }

  describe "#initialize" do
    it "must set #wordlist" do
      expect(subject.wordlist).to eq(wordlist)
    end

    it "must set #chars" do
      expect(subject.chars).to eq(chars)
    end

    it "must set #replace" do
      expect(subject.replace).to eq(replace)
    end
  end

  describe "#each" do
    let(:expected_words) do
      wordlist.map { |word| word.tr(chars,replace) }
    end

    context "when given a block" do
      it "must call #gsub on each word" do
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args(*expected_words)
      end
    end

    context "when not given a block" do
      it "must return an Enumerator object for #each" do
        expect(subject.each).to be_kind_of(Enumerator)
        expect(subject.each.to_a).to eq(expected_words)
      end
    end
  end
end
