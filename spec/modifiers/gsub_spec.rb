require 'spec_helper'
require 'wordlist/modifiers/gsub'

describe Wordlist::Modifiers::Gsub do
  let(:wordlist) { %w[foo bar baz] }

  let(:pattern) { /o/ }
  let(:replace) { '0' }

  subject { described_class.new(wordlist,pattern,replace) }

  describe "#each" do
    context "when initialized with a replacement String" do
      let(:expected_words) do
        wordlist.map { |word| word.gsub(pattern,replace) }
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

    context "when initialized with a replacement block" do
      let(:block) { ->(word) { '0' } }

      subject { described_class.new(wordlist,pattern,&block) }

      let(:expected_words) do
        wordlist.map { |word| word.gsub(pattern,&block) }
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
end
