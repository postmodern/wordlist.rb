require 'spec_helper'
require 'wordlist/txt'

describe Wordlist::TXT do
  let(:fixtures_dir) { File.join(__dir__,'fixtures') }
  let(:path) { File.join(fixtures_dir,'wordlist.txt') }

  subject { described_class.new(path) }

  describe "#initialize" do
    it "must set #path" do
      expect(subject.path).to eq(path)
    end

    context "when given a relative path" do
      let(:relative_path) { "../fixtures/wordlist.txt" }
      
      subject { described_class.new(relative_path) }

      it "must expand the given path" do
        expect(subject.path).to eq(File.expand_path(relative_path))
      end
    end
  end

  describe ".open" do
    subject { described_class.open(path) }

    it { expect(subject).to be_kind_of(described_class) }

    it "must initialize #path" do
      expect(subject.path).to eq(path)
    end
  end

  let(:expected_words) { File.readlines(path).map(&:chomp) }

  describe ".read" do
    subject { described_class }

    it "must open the wordlist and enumerate over each word" do
      expect { |b|
        subject.read(path,&b)
      }.to yield_successive_args(*expected_words)
    end
  end

  describe "#each_line" do
    let(:expected_lines) { File.readlines(path) }

    context "when given a block" do
      it "must yield each read line of the file" do
        expect { |b|
          subject.each_line(&b)
        }.to yield_successive_args(*expected_lines)
      end
    end

    context "when not given a block" do
      it "must return an Enumerator" do
        expect(subject.each_line).to be_kind_of(Enumerator)
        expect(subject.each_line.to_a).to eq(expected_lines)
      end
    end
  end

  describe "#each" do
    it "must yield each word on each line" do
      expect { |b|
        subject.each(&b)
      }.to yield_successive_args(*expected_words)
    end

    context "when the wordlist contains empty lines" do
      let(:expected_words) do
        super().reject { |w| w.empty? }
      end

      it "must omit empty lines" do
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args(*expected_words)
      end
    end

    context "when the wordlist contains comment lines" do
      let(:expected_words) do
        super().reject { |w| w.start_with?('#') }
      end

      it "must omit lines beginning with a '#'" do
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args(*expected_words)
      end
    end
  end
end
