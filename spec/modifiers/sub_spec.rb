require 'spec_helper'
require 'wordlist/modifiers/sub'

describe Wordlist::Modifiers::Sub do
  let(:wordlist) { %w[foo bar baz] }

  let(:pattern) { /o/ }
  let(:replace) { '0' }

  let(:block) do
    proc { |match| match.swapcase }
  end

  subject { described_class.new(wordlist,pattern,replace) }

  describe "#initialize" do
    it "must set #wordlist" do
      expect(subject.wordlist).to eq(wordlist)
    end

    it "must set #pattern" do
      expect(subject.pattern).to eq(pattern)
    end

    it "must set #replace" do
      expect(subject.replace).to eq(replace)
    end

    it "must default #block to nil" do
      expect(subject.block).to be(nil)
    end

    context "when the replacement value is a String" do
      it "must set #replace" do
        expect(subject.replace).to eq(replace)
      end
    end

    context "when the replacement value is a Hash" do
      let(:replace) { {'o' => '0', 'e' => '3', 'a' => '@'} }

      it "must set #replace" do
        expect(subject.replace).to eq(replace)
      end
    end

    context "when the replacement value is nil" do
      let(:replace) { nil }

      it "must not set #replace" do
        expect(subject.replace).to be(nil)
      end
    end

    context "when a block is given" do
      subject { described_class.new(wordlist,pattern,&block) }

      it "must set #block" do
        expect(subject.block).to eq(block)
      end
    end
  end

  describe "#each" do
    let(:expected_words) do
      wordlist.map { |word| word.sub(pattern,replace) }
    end

    context "when given a block" do
      it "must call #sub on each word" do
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args(*expected_words)
      end

      context "when initialized with no replacement String but with a block" do
        subject { described_class.new(wordlist,pattern,&block) }

        let(:expected_words) do
          wordlist.map { |word| word.sub(pattern,&block) }
        end

        it "must pass the block to #sub" do
          expect { |b|
            subject.each(&b)
          }.to yield_successive_args(*expected_words)
        end
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
