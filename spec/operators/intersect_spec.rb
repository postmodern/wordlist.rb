require 'spec_helper'
require 'wordlist/operators/intersect'

describe Wordlist::Operators::Intersect do
  let(:left)  { %w[foo bar] }
  let(:right) { %w[bar baz] }

  subject { described_class.new(left,right) }

  describe "#each" do
    context "when given a block" do
      it "must yield the words which exist in both wordlists" do
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args(*(left & right))
      end

      context "when the wordlists do not have any common words" do
        let(:left)  { %w[foo bar] }
        let(:right) { %w[baz qux] }

        it "must not yield any words" do
          expect { |b|
            subject.each(&b)
          }.to_not yield_control
        end
      end
    end

    context "when not given a block" do
      it "must return an Enumerator for the #each" do
        expect(subject.each).to be_kind_of(Enumerator)
        expect(subject.each.to_a).to eq(left & right)
      end
    end
  end
end
