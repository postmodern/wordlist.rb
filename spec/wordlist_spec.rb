require 'spec_helper'
require 'wordlist'

describe Wordlist do
  it "should have a VERSION constant" do
    expect(Wordlist.const_defined?('VERSION')).to be(true)
  end

  let(:fixtures_dir) { ::File.join(__dir__,'fixtures') }

  describe ".open" do
    let(:path) { ::File.join(fixtures_dir,'wordlist.txt') }

    it "must return a Wordlist::File object" do
      expect(subject.open(path)).to be_kind_of(Wordlist::File)
    end

    context "when given a block" do
      it "must yield the Wordlist::File object" do
        expect { |b|
          subject.open(path,&b)
        }.to yield_with_args(Wordlist::File)
      end
    end
  end

  describe ".build" do
    let(:path) { ::File.join(fixtures_dir,'new_wordlist.txt') }

    it "must return a Wordlist::Builder object" do
      expect(subject.build(path)).to be_kind_of(Wordlist::Builder)
    end

    context "when given a block" do
      it "must yield the Wordlist::Builder object" do
        expect { |b|
          subject.build(path,&b)
        }.to yield_with_args(Wordlist::Builder)
      end
    end

    after { ::FileUtils.rm_f(path) }
  end
end
