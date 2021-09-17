require 'spec_helper'
require 'wordlist/unique_filter'

describe UniqueFilter do
  describe "#initialize" do
    it "must initialize #hashes to an empty Set" do
      expect(subject.hashes).to be_kind_of(Set)
      expect(subject.hashes).to be_empty
    end
  end

  describe "#<<" do
    let(:string) { "foo" }

    before { subject << string }

    it "must add the String's hash to #hashes" do
      expect(subject.hashes.include?(string.hash)).to be(true)
    end

    context "when the same string is added twice" do
      before do
        subject << string
        subject << string
      end

      it "must add the String's hash to #hashes only once" do
        expect(subject.hashes).to eq(Set[string.hash])
      end
    end
  end

  describe "#include?" do
    let(:string) { "foo" }

    before { subject << string }

    context "when the unique filter contains the String's hash" do
      it "must return true" do
        expect(subject.include?(string)).to be(true)
      end
    end

    context "when the unqiue filter does not contain the String's hash" do
      it "must return false" do
        expect(subject.include?("XXX")).to be(false)
      end
    end
  end
end
