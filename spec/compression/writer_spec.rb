require 'spec_helper'
require 'wordlist/compression/writer'

require 'fileutils'

describe Wordlist::Compression::Writer do
  describe ".command" do
    let(:path) { 'path/to/file' }

    context "when given format: :gzip" do
      subject { described_class.command(path, format: :gzip) }

      it "must return 'gzip > path/to/file'" do
        expect(subject).to eq("gzip > #{path}")
      end

      context "and given append: true" do
        subject { described_class.command(path, format: :gzip, append: true) }

        it "must return 'gzip >> path/to/file'" do
          expect(subject).to eq("gzip >> #{path}")
        end
      end

      context "and the file contains special characters" do
        let(:path) { 'path/to/the file' }

        it "must shellescape them" do
          expect(subject).to eq("gzip > #{Shellwords.shellescape(path)}")
        end
      end
    end

    context "when given format: :bzip2" do
      subject { described_class.command(path, format: :bzip2) }

      it "must return 'bzip2 > path/to/file'" do
        expect(subject).to eq("bzip2 > #{path}")
      end

      context "and given append: true" do
        subject { described_class.command(path, format: :bzip2, append: true) }

        it "must return 'bzip2 >> path/to/file'" do
          expect(subject).to eq("bzip2 >> #{path}")
        end
      end

      context "and the file contains special characters" do
        let(:path) { 'path/to/the file' }

        it "must shellescape them" do
          expect(subject).to eq("bzip2 > #{Shellwords.shellescape(path)}")
        end
      end
    end

    context "when given format: :xz" do
      subject { described_class.command(path, format: :xz) }

      it "must return 'xz > path/to/file'" do
        expect(subject).to eq("xz > #{path}")
      end

      context "and given append: true" do
        subject { described_class.command(path, format: :xz, append: true) }

        it "must return 'xz >> path/to/file'" do
          expect(subject).to eq("xz >> #{path}")
        end
      end

      context "and the file contains special characters" do
        let(:path) { 'path/to/the file' }

        it "must shellescape them" do
          expect(subject).to eq("xz > #{Shellwords.shellescape(path)}")
        end
      end
    end

    context "when given an unknown format: value" do
      let(:format) { :foo }

      it do
        expect {
          subject.command(path, format: format)
        }.to raise_error(Wordlist::UnknownFormat,"unsupported output format: #{format.inspect}")
      end
    end
  end

  describe ".open" do
    let(:fixtures_dir) { ::File.join(__dir__,'..','fixtures') }

    let(:words) { %w[foo bar] }

    context "when given format: :gzip" do
      let(:path) { ::File.join(fixtures_dir,'new_wordlist.txt.gz') }

      subject { described_class.open(path, format: :gzip) }

      it "must return an IO object" do
        expect(subject).to be_kind_of(IO)
      end

      context "when written to" do
        before do
          subject.puts words
          subject.close
        end

        let(:written_contents) { `zcat < #{Shellwords.shellescape(path)}` }
        let(:written_words)    { written_contents.lines.map(&:chomp)    }

        it "must writing gzip compressed data to the file" do
          expect(written_words).to eq(words)
        end
      end

      after { ::FileUtils.rm_f(path) }
    end

    context "when given format: :bzip2" do
      let(:path) { ::File.join(fixtures_dir,'new_wordlist.txt.bz2') }

      subject { described_class.open(path, format: :bzip2) }

      it "must return an IO object" do
        expect(subject).to be_kind_of(IO)
      end

      context "when written to" do
        before do
          subject.puts words
          subject.close
        end

        let(:written_contents) { `bzcat < #{Shellwords.shellescape(path)}` }
        let(:written_words)    { written_contents.lines.map(&:chomp)    }

        it "must writing bzip2 compressed data to the file" do
          expect(written_words).to eq(words)
        end
      end

      after { ::FileUtils.rm_f(path) }
    end

    context "when given format: :xz" do
      let(:path) { ::File.join(fixtures_dir,'new_wordlist.txt.xz') }

      subject { described_class.open(path, format: :xz) }

      it "must return an IO object" do
        expect(subject).to be_kind_of(IO)
      end

      context "when written to" do
        before do
          subject.puts words
          subject.close
        end

        let(:written_contents) { `xzcat < #{Shellwords.shellescape(path)}` }
        let(:written_words)    { written_contents.lines.map(&:chomp)    }

        it "must writing xz compressed data to the file" do
          expect(written_words).to eq(words)
        end
      end

      after { ::FileUtils.rm_f(path) }
    end

    context "when the command is not installed" do
      let(:format)  { :gzip  }
      let(:command) { "gzip > #{Shellwords.shellescape(path)}" }
      let(:path)    { ::File.join(fixtures_dir,'new_wordlist.txt.gz') }

      before do
        expect(IO).to receive(:popen).with(command,'w').and_raise(Errno::ENOENT)
      end

      it do
        expect {
          described_class.open(path, format: format)
        }.to raise_error(Wordlist::CommandNotFound,"#{command.inspect} command not found")
      end

      after { ::FileUtils.rm_f(path) }
    end
  end
end
