require 'spec_helper'
require 'wordlist/modifiers/mutate'

describe Wordlist::Modifiers::Mutate do
  let(:wordlist) { %w[foo bar] }

  let(:pattern) { /[oa]/ }
  let(:replace) { {'o' => '0', 'a' => '@'} }

  subject { described_class.new(wordlist,pattern,replace) }

  describe "#each" do
    let(:expected_words) do
      %w[
        foo
        f0o
        fo0
        f00
        bar
        b@r
      ]
    end

    context "when given a block" do
      it "must enumerate through every possible string substitution combination" do
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
