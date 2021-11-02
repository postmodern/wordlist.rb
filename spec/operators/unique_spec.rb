require 'spec_helper'
require 'wordlist/operators/unique'

describe Wordlist::Operators::Unique do
  let(:wordlist)  { %w[foo bar bar baz foo qux] }

  subject { described_class.new(wordlist) }

  describe "#each" do
    context "when given a block" do
      it "must yield the unique words from the wordlist" do
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args(*wordlist.uniq)
      end
    end

    context "when not given a block" do
      it "must return an Enumerator for the #each" do
        expect(subject.each).to be_kind_of(Enumerator)
        expect(subject.each.to_a).to eq(wordlist.uniq)
      end
    end
  end
end
