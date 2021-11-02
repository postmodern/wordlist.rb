require 'spec_helper'
require 'wordlist/list_methods'

describe Wordlist::ListMethods do
  module TestWordlist
    class TestListMethods
      include Wordlist::ListMethods
    end
  end

  subject { TestWordlist::TestListMethods.new }

  let(:other) { double(:other_list) }

  describe "#concat" do
    it "must return an Operators::Concat object with the list and the other list" do
      expect(Operators::Concat).to receive(:new).with(subject,other)

      subject.concat(other)
    end
  end

  describe "#subtract" do
    it "must return an Operators::Subtract object with the list and the other list" do
      expect(Operators::Subtract).to receive(:new).with(subject,other)

      subject.subtract(other)
    end
  end

  describe "#product" do
    it "must return an Operators::Product object with the list and the other list" do
      expect(Operators::Product).to receive(:new).with(subject,other)

      subject.product(other)
    end
  end

  describe "#power" do
    let(:exponent) { 3 }

    it "must return an Operators::Power object with the list and an exponent" do
      expect(Operators::Power).to receive(:new).with(subject,exponent)

      subject.power(exponent)
    end
  end

  describe "#intersect" do
    it "must return an Operators::Intersect object with the list and the other list" do
      expect(Operators::Intersect).to receive(:new).with(subject,other)

      subject.intersect(other)
    end
  end

  describe "#union" do
    it "must return an Operators::Union object with the list and the other list" do
      expect(Operators::Union).to receive(:new).with(subject,other)

      subject.union(other)
    end
  end

  describe "#uniq" do
    it "must return an Operators::Uniq object with the list" do
      expect(Operators::Unique).to receive(:new).with(subject)

      subject.uniq
    end
  end

  describe "#tr" do
    let(:chars)   { double(:chars)   }
    let(:replace) { double(:replace) }

    it "must return an Modifiers::Tr object with the list, chars, and replace" do
      expect(Modifiers::Tr).to receive(:new).with(subject,chars,replace)

      subject.tr(chars,replace)
    end
  end

  describe "#sub" do
    let(:pattern) { double(:pattern)   }
    let(:replace) { double(:replace) }

    it "must return an Modifiers::Sub object with the list, pattern, and replace" do
      expect(Modifiers::Sub).to receive(:new).with(subject,pattern,replace)

      subject.sub(pattern,replace)
    end

    context "when replace is nil and a block is given" do
      let(:replace) { nil }
      let(:block)   { ->(match) { '0' } }

      it "must return an Modifiers::Sub object with the list, pattern, and block" do
        expect(Modifiers::Sub).to receive(:new).with(subject,pattern)

        subject.sub(pattern,replace)
      end
    end
  end

  describe "#gsub" do
    let(:pattern) { double(:pattern)   }
    let(:replace) { double(:replace) }

    it "must return an Modifiers::Gsub object with the list, pattern, and replace" do
      expect(Modifiers::Gsub).to receive(:new).with(subject,pattern,replace)

      subject.gsub(pattern,replace)
    end

    context "when replace is nil and a block is given" do
      let(:replace) { nil }
      let(:block)   { ->(match) { '0' } }

      it "must return an Modifiers::Gsub object with the list, pattern, and block" do
        expect(Modifiers::Gsub).to receive(:new).with(subject,pattern)

        subject.gsub(pattern,replace)
      end
    end
  end

  describe "#capitalize" do
    it "must return an Modifiers::Capitalize object with the list" do
      expect(Modifiers::Capitalize).to receive(:new).with(subject)

      subject.capitalize
    end
  end

  describe "#upcase" do
    it "must return an Modifiers::Upcase object with the list" do
      expect(Modifiers::Upcase).to receive(:new).with(subject)

      subject.upcase
    end
  end

  describe "#downcase" do
    it "must return an Modifiers::Downcase object with the list" do
      expect(Modifiers::Downcase).to receive(:new).with(subject)

      subject.downcase
    end
  end

  describe "#mutate" do
    let(:pattern) { double(:pattern) }
    let(:replace) { double(:replace) }

    it "must return an Modifiers::Mutate object with the list, pattern, and replace" do
      expect(Modifiers::Mutate).to receive(:new).with(subject,pattern,replace)

      subject.mutate(pattern,replace)
    end

    context "when replace is nil and a block is given" do
      let(:replace) { nil }
      let(:block)   { ->(match) { '0' } }

      it "must return an Modifiers::Mutate object with the list, pattern, and block" do
        expect(Modifiers::Mutate).to receive(:new).with(subject,pattern)

        subject.mutate(pattern,replace)
      end
    end
  end

  describe "#mutate_case" do
    it "must return an Modifiers::MutateCase object with the list" do
      expect(Modifiers::MutateCase).to receive(:new).with(subject)

      subject.mutate_case
    end
  end
end
