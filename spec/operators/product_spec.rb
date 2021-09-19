require 'spec_helper'
require 'wordlist/operators/product'

describe Wordlist::Operators::Product do
  let(:left)  { %w[foo bar baz qux] }
  let(:right) { %w[abc xyz] }

  subject { described_class.new(left,right) }

  let(:expected_words) do
    %w[
        fooabc
        fooxyz
        barabc
        barxyz
        bazabc
        bazxyz
        quxabc
        quxxyz
    ]
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
