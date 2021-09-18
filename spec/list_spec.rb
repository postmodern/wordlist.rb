require 'spec_helper'
require 'wordlist/list'

describe Wordlist::List do
  let(:words) { %w[foo bar baz] }

  subject { described_class.new(words) }

  describe "#initialize" do
    it "must set #words" do
      expect(subject.words).to eq(words)
    end
  end

  describe ".[]" do
    subject { described_class[*words] }

    it "must return a new #{described_class}" do
      expect(subject).to be_kind_of(described_class)
    end

    it "must initialize the wordlist with the given words" do
      expect(subject.words).to eq(words)
    end
  end

  describe "#each" do
    context "when a block is given" do
      it "must yield each word" do
        expect { |b| subject.each(&b) }.to yield_successive_args(*words)
      end
    end

    context "when no block is given" do
      it "must return an Enumerator for the words" do
        expect(subject.each).to be_kind_of(Enumerator)
        expect(subject.each.to_a).to eq(words)
      end
    end
  end
end
