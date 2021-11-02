require 'spec_helper'
require 'wordlist/operators/concat'

describe Wordlist::Operators::Concat do
  let(:left)  { %w[foo bar] }
  let(:right) { %w[baz qux] }

  subject { described_class.new(left,right) }

  describe "#each" do
    context "when given a block" do
      it "must yield each word from both wordlists" do
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args(*(left + right))
      end
    end

    context "when not given a block" do
      it "must return an Enumerator for the #each" do
        expect(subject.each).to be_kind_of(Enumerator)
        expect(subject.each.to_a).to eq(left + right)
      end
    end
  end
end
