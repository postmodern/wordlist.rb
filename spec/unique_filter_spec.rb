require 'spec_helper'
require 'wordlist/unique_filter'

describe Wordlist::UniqueFilter do
  describe "#initialize" do
    it "must initialize #hashes to an empty Set" do
      expect(subject.hashes).to be_kind_of(Set)
      expect(subject.hashes).to be_empty
    end
  end

  describe "#add" do
    let(:word) { "foo" }

    before { subject.add(word) }

    it "must add the String's hash to #hashes" do
      expect(subject.hashes.include?(word.hash)).to be(true)
    end

    context "when the same word is added twice" do
      before do
        subject.add(word)
        subject.add(word)
      end

      it "must add the String's hash to #hashes only once" do
        expect(subject.hashes).to eq(Set[word.hash])
      end
    end
  end

  describe "#include?" do
    let(:word) { "foo" }

    before { subject.add(word) }

    context "when the unique filter contains the String's hash" do
      it "must return true" do
        expect(subject.include?(word)).to be(true)
      end
    end

    context "when the unqiue filter does not contain the String's hash" do
      it "must return false" do
        expect(subject.include?("XXX")).to be(false)
      end
    end
  end

  describe "#add?" do
    let(:word) { "foo" }

    before { subject.add(word) }

    context "when the unique filter already contains the String's hash" do
      it "must return false" do
        expect(subject.add?(word)).to be(false)
      end
    end

    context "when the unqiue filter does not contain the String's hash" do
      let(:new_word) { "bar" }

      it "must return true" do
        expect(subject.add?(new_word)).to be(true)
      end
    end
  end

  describe "#empty?" do
    context "when no words have been added to the unique filter" do
      it "must return true" do
        expect(subject.empty?).to be(true)
      end
    end

    context "when words have been added to the unique filter" do
      let(:word) { 'foo' }

      before { subject.add(word) }

      it "must return false" do
        expect(subject.empty?).to be(false)
      end
    end
  end

  describe "#clear" do
    let(:word1) { 'foo' }
    let(:word2) { 'bar' }

    before do
      subject.add(word1)
      subject.clear
      subject.add(word2)
    end

    it "must clear the unique filter of any words" do
      expect(subject.include?(word1)).to be(false)
      expect(subject.include?(word2)).to be(true)
    end
  end

  describe "#size" do
    it "must return 0 by default" do
      expect(subject.size).to eq(0)
    end

    context "when the unique filter has been populated" do
      let(:words) { %w[foo bar baz] }

      before do
        words.each do |word|
          subject.add(word)
        end
      end

      it "must return the number of unique words added to the filter" do
        expect(subject.size).to eq(words.length)
      end
    end
  end
end
