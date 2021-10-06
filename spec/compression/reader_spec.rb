require 'spec_helper'
require 'wordlist/compression/reader'

describe Wordlist::Compression::Reader do
  describe ".command" do
    let(:path) { 'path/to/file' }

    context "when given format: :gzip" do
      subject { described_class.command(path, format: :gzip) }

      it "must return 'zcat path/to/file'" do
        expect(subject).to eq("zcat #{path}")
      end

      context "and the file contains special characters" do
        let(:path) { 'path/to/the file' }

        it "must shellescape them" do
          expect(subject).to eq("zcat #{Shellwords.shellescape(path)}")
        end
      end
    end

    context "when given format: :bzip2" do
      subject { described_class.command(path, format: :bzip2) }

      it "must return 'bzcat path/to/file'" do
        expect(subject).to eq("bzcat #{path}")
      end

      context "and the file contains special characters" do
        let(:path) { 'path/to/the file' }

        it "must shellescape them" do
          expect(subject).to eq("bzcat #{Shellwords.shellescape(path)}")
        end
      end
    end

    context "when given format: :xz" do
      subject { described_class.command(path, format: :xz) }

      it "must return 'xzcat path/to/file'" do
        expect(subject).to eq("xzcat #{path}")
      end

      context "and the file contains special characters" do
        let(:path) { 'path/to/the file' }

        it "must shellescape them" do
          expect(subject).to eq("xzcat #{Shellwords.shellescape(path)}")
        end
      end
    end

    context "when given an unknown format: value" do
      let(:format) { :foo }

      it do
        expect {
          subject.command(path, format: format)
        }.to raise_error(ArgumentError,"unsupported format: #{format.inspect}")
      end
    end
  end

  describe ".open" do
    let(:fixtures_dir) { File.join(__dir__,'..','fixtures') }

    context "when given format: :gzip" do
      let(:path) { File.join(fixtures_dir,'wordlist.txt.gz') }
      let(:expected_contents) { `zcat #{Shellwords.shellescape(path)}` }

      subject { described_class.open(path, format: :gzip) }

      it "must return an IO object" do
        expect(subject).to be_kind_of(IO)
      end

      context "when read from" do
        it "must read the uncompressed contents of the wordllist" do
          expect(subject.read).to eq(expected_contents)
        end
      end
    end

    context "when given format: :bzip2" do
      let(:path) { File.join(fixtures_dir,'wordlist.txt.bz2') }
      let(:expected_contents) { `bzcat #{Shellwords.shellescape(path)}` }

      subject { described_class.open(path, format: :bzip2) }

      it "must return an IO object" do
        expect(subject).to be_kind_of(IO)
      end

      context "when read from" do
        it "must read the uncompressed contents of the wordllist" do
          expect(subject.read).to eq(expected_contents)
        end
      end
    end

    context "when given format: :xz" do
      let(:path) { File.join(fixtures_dir,'wordlist.txt.xz') }
      let(:expected_contents) { `xzcat #{Shellwords.shellescape(path)}` }

      subject { described_class.open(path, format: :xz) }

      it "must return an IO object" do
        expect(subject).to be_kind_of(IO)
      end

      context "when read from" do
        it "must read the uncompressed contents of the wordllist" do
          expect(subject.read).to eq(expected_contents)
        end
      end
    end
  end
end
