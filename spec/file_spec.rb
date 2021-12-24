require 'spec_helper'
require 'wordlist/file'

describe Wordlist::File do
  let(:fixtures_dir) { ::File.join(__dir__,'fixtures') }
  let(:path) { ::File.join(fixtures_dir,'wordlist.txt') }

  subject { described_class.new(path) }

  describe "#initialize" do
    it "must set #path" do
      expect(subject.path).to eq(path)
    end

    context "when initialized with non-existant path" do
      let(:path) { '/does/not/exist.txt' }

      it do
        expect {
          described_class.new(path)
        }.to raise_error(Wordlist::WordlistNotFound,"wordlist file does not exist: #{path.inspect}")
      end

      context "and the path is relative" do
        let(:path)          { 'does/not/exist.txt'   }
        let(:absolute_path) { File.expand_path(path) }

        it "must include the absolute path in the exception message" do
          expect {
            described_class.new(path)
          }.to raise_error(Wordlist::WordlistNotFound,"wordlist file does not exist: #{absolute_path.inspect}")
        end
      end
    end

    context "when given a relative path" do
      let(:relative_path) { ::File.join(__FILE__,"../fixtures/wordlist.txt") }
      
      subject { described_class.new(relative_path) }

      it "must expand the given path" do
        expect(subject.path).to eq(::File.expand_path(relative_path))
      end
    end

    context "when format: is not given" do
      context "and the path ends in .txt" do
        let(:path) { ::File.join(fixtures_dir,'wordlist.txt') }

        it "must set #format to :txt" do
          expect(subject.format).to eq(:txt)
        end
      end

      context "and the path ends in .gz" do
        let(:path) { ::File.join(fixtures_dir,'wordlist.txt.gz') }

        it "must set #format to :gzip" do
          expect(subject.format).to eq(:gzip)
        end
      end

      context "and the path ends in .bz2" do
        let(:path) { ::File.join(fixtures_dir,'wordlist.txt.bz2') }

        it "must set #format to :bzip2" do
          expect(subject.format).to eq(:bzip2)
        end
      end

      context "and the path ends in .xz" do
        let(:path) { ::File.join(fixtures_dir,'wordlist.txt.xz') }

        it "must set #format to :xz" do
          expect(subject.format).to eq(:xz)
        end
      end

      context "and the path ends in .zip" do
        let(:path) { ::File.join(fixtures_dir,'wordlist.txt.zip') }

        it "must set #format to :zip" do
          expect(subject.format).to eq(:zip)
        end
      end
    end

    context "when format: is given" do
      let(:format) { :gzip }

      subject { described_class.new(path, format: format) }

      it "must set #format" do
        expect(subject.format).to eq(format)
      end

      context "but it's an unknown format" do
        let(:format) { :foo }

        it do
          expect {
            described_class.new(path, format: format)
          }.to raise_error(Wordlist::UnknownFormat,"unknown format given: #{format.inspect}")
        end
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

  let(:expected_contents) { ::File.read(path) }
  let(:expected_lines)    { expected_contents.lines }
  let(:expected_words)    { expected_lines.map(&:chomp) }

  describe ".read" do
    subject { described_class }

    it "must open the wordlist and enumerate over each word" do
      expect { |b|
        subject.read(path,&b)
      }.to yield_successive_args(*expected_words)
    end
  end

  describe "#each_line" do
    context "when given a block" do
      it "must yield each read line of the file" do
        expect { |b|
          subject.each_line(&b)
        }.to yield_successive_args(*expected_lines)
      end

      context "and the wordlist format is gzip" do
        let(:path) { ::File.join(fixtures_dir,'wordlist.txt.gz') }
        let(:expected_contents) { `zcat < #{Shellwords.shellescape(path)}` }

        it "must read the uncompressed gzip data" do
          expect { |b|
            subject.each_line(&b)
          }.to yield_successive_args(*expected_lines)
        end
      end

      context "and the wordlist format is bzip2" do
        let(:path) { ::File.join(fixtures_dir,'wordlist.txt.bz2') }
        let(:expected_contents) { `bzcat < #{Shellwords.shellescape(path)}` }

        it "must read the uncompressed gzip data" do
          expect { |b|
            subject.each_line(&b)
          }.to yield_successive_args(*expected_lines)
        end
      end

      context "and the wordlist format is xz" do
        let(:path) { ::File.join(fixtures_dir,'wordlist.txt.xz') }
        let(:expected_contents) { `xzcat < #{Shellwords.shellescape(path)}` }

        it "must read the uncompressed gzip data" do
          expect { |b|
            subject.each_line(&b)
          }.to yield_successive_args(*expected_lines)
        end
      end
    end

    context "when not given a block" do
      it "must return an Enumerator" do
        expect(subject.each_line).to be_kind_of(Enumerator)
        expect(subject.each_line.to_a).to eq(expected_lines)
      end

      context "and the wordlist format is gzip" do
        let(:path) { ::File.join(fixtures_dir,'wordlist.txt.gz') }
        let(:expected_contents) { `zcat < #{Shellwords.shellescape(path)}` }

        it "must return an Enumerator of the uncompressed gzip data" do
          expect(subject.each_line).to be_kind_of(Enumerator)
          expect(subject.each_line.to_a).to eq(expected_lines)
        end
      end

      context "and the wordlist format is bzip2" do
        let(:path) { ::File.join(fixtures_dir,'wordlist.txt.bz2') }
        let(:expected_contents) { `bzcat < #{Shellwords.shellescape(path)}` }

        it "must return an Enumerator of the compressed gzip data" do
          expect(subject.each_line).to be_kind_of(Enumerator)
          expect(subject.each_line.to_a).to eq(expected_lines)
        end
      end

      context "and the wordlist format is xz" do
        let(:path) { ::File.join(fixtures_dir,'wordlist.txt.xz') }
        let(:expected_contents) { `xzcat < #{Shellwords.shellescape(path)}` }

        it "must return an Enumerator of the compressed gzip data" do
          expect(subject.each_line).to be_kind_of(Enumerator)
          expect(subject.each_line.to_a).to eq(expected_lines)
        end
      end
    end
  end

  describe "#each" do
    it "must yield each word on each line" do
      expect { |b|
        subject.each(&b)
      }.to yield_successive_args(*expected_words)
    end

    context "and the wordlist format is gzip" do
      let(:path) { ::File.join(fixtures_dir,'wordlist.txt.gz') }
      let(:expected_contents) { `zcat < #{Shellwords.shellescape(path)}` }

      it "must read the uncompressed gzip data" do
        expect { |b|
          subject.each_line(&b)
        }.to yield_successive_args(*expected_lines)
      end
    end

    context "and the wordlist format is bzip2" do
      let(:path) { ::File.join(fixtures_dir,'wordlist.txt.bz2') }
      let(:expected_contents) { `bzcat < #{Shellwords.shellescape(path)}` }

      it "must read the uncompressed gzip data" do
        expect { |b|
          subject.each_line(&b)
        }.to yield_successive_args(*expected_lines)
      end
    end

    context "and the wordlist format is xz" do
      let(:path) { ::File.join(fixtures_dir,'wordlist.txt.xz') }
      let(:expected_contents) { `xzcat < #{Shellwords.shellescape(path)}` }

      it "must read the uncompressed gzip data" do
        expect { |b|
          subject.each_line(&b)
        }.to yield_successive_args(*expected_lines)
      end
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
