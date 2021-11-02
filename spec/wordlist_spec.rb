require 'spec_helper'
require 'wordlist'

describe Wordlist do
  it "should have a VERSION constant" do
    expect(Wordlist.const_defined?('VERSION')).to be(true)
  end

  describe ".[]" do
    let(:words) { %w[foo bar baz] }

    subject { described_class[*words] }

    it "must return a Wordlist::Words object with the given words" do
      expect(subject).to be_kind_of(Wordlist::Words)
      expect(subject.words).to eq(words)
    end
  end

  let(:fixtures_dir) { ::File.join(__dir__,'fixtures') }

  describe ".open" do
    let(:path) { ::File.join(fixtures_dir,'wordlist.txt') }

    subject { described_class.open(path) }

    it "must return a Wordlist::File object using the given path" do
      expect(subject).to be_kind_of(Wordlist::File)
      expect(subject.path).to eq(path)
    end

    context "when given a block" do
      it "must yield the Wordlist::File object" do
        expect { |b|
          described_class.open(path,&b)
        }.to yield_with_args(Wordlist::File)
      end
    end
  end

  describe ".build" do
    let(:path) { ::File.join(fixtures_dir,'new_wordlist.txt') }

    subject { described_class.build(path) }

    it "must return a Wordlist::Builder object using the given path" do
      expect(subject).to be_kind_of(Wordlist::Builder)
      expect(subject.path).to eq(path)
    end

    context "when given a block" do
      it "must yield the Wordlist::Builder object" do
        expect { |b|
          described_class.build(path,&b)
        }.to yield_with_args(Wordlist::Builder)
      end
    end

    after { ::FileUtils.rm_f(path) }
  end
end
