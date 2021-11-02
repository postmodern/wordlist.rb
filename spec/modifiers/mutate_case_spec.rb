require 'spec_helper'
require 'wordlist/modifiers/mutate_case'

describe Wordlist::Modifiers::MutateCase do
  let(:wordlist) { %w[foo BaR] }

  subject { described_class.new(wordlist) }

  describe "#each" do
    let(:expected_words) do
      %w[
        foo
        Foo
        fOo
        foO
        FOo
        FoO
        fOO
        FOO
        BaR
        baR
        BAR
        Bar
        bAR
        bar
        BAr
        bAr
      ]
    end

    context "when given a block" do
      it "must enumerate through every possible uppercase/lowercase combination" do
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
