require 'spec_helper'
require 'wordlist/builder'

require 'fileutils'

describe Wordlist::Builder do
  let(:fixtures_dir) { ::File.join(__dir__,'fixtures') }
  let(:path)         { ::File.join(fixtures_dir,'new_wordlist.txt') }

  subject { described_class.new(path) }

  describe "#initialize" do
    it "must initialize the #path" do
      expect(subject.path).to eq(path)
    end

    context "when the path ends in '.txt'" do
      let(:path) { ::File.join(fixtures_dir,'new_wordlist.txt') }

      it "must default #format to :txt" do
        expect(subject.format).to eq(:txt)
      end
    end

    context "when the path ends in '.gz'" do
      let(:path) { ::File.join(fixtures_dir,'new_wordlist.gz') }

      it "must default #format to :gzip" do
        expect(subject.format).to eq(:gzip)
      end
    end

    context "when the path ends in '.bz2'" do
      let(:path) { ::File.join(fixtures_dir,'new_wordlist.bz2') }

      it "must default #format to :bzip2" do
        expect(subject.format).to eq(:bzip2)
      end
    end

    context "when the path ends in '.xz'" do
      let(:path) { ::File.join(fixtures_dir,'new_wordlist.xz') }

      it "must default #format to :xz" do
        expect(subject.format).to eq(:xz)
      end
    end

    context "when the path ends in '.zip'" do
      let(:path) { ::File.join(fixtures_dir,'new_wordlist.zip') }

      it "must default #format to :zip" do
        expect(subject.format).to eq(:zip)
      end
    end

    context "when the path ends in '.7z'" do
      let(:path) { ::File.join(fixtures_dir,'new_wordlist.7z') }

      it "must default #format to :7zip" do
        expect(subject.format).to eq(:"7zip")
      end
    end

    context "when format: :txt is given" do
      subject { described_class.new(path, format: :txt) }

      it "must set #format to :txt" do
        expect(subject.format).to eq(:txt)
      end
    end

    context "when format: :gzip is given" do
      subject { described_class.new(path, format: :gzip) }

      it "must set #format to :gzip" do
        expect(subject.format).to eq(:gzip)
      end
    end

    context "when format: :bzip2 is given" do
      subject { described_class.new(path, format: :bzip2) }

      it "must set #format to :bzip2" do
        expect(subject.format).to eq(:bzip2)
      end
    end

    context "when format: :xz is given" do
      subject { described_class.new(path, format: :xz) }

      it "must set #format to :xz" do
        expect(subject.format).to eq(:xz)
      end
    end

    context "when format: :zip is given" do
      subject { described_class.new(path, format: :zip) }

      it "must set #format to :zip" do
        expect(subject.format).to eq(:zip)
      end
    end

    context "when format: :7zip is given" do
      subject { described_class.new(path, format: :"7zip") }

      it "must set #format to :7zip" do
        expect(subject.format).to eq(:"7zip")
      end
    end

    it "must default #append? to false" do
      expect(subject.append?).to be(false)
    end

    it "#unique_filter must be empty" do
      expect(subject.unique_filter).to be_empty
    end

    it "must open the wordlist file" do
      expect(subject).to_not be_closed
    end

    context "when given append: true" do
      context "and the wordlist file already exists" do
        let(:path) { ::File.join(fixtures_dir,'pre_existing_wordlist.txt') }
        let(:pre_existing_words) { %w[foo bar] }

        subject { described_class.new(path, append: true) }

        before do
          ::File.open(path,'w') do |file|
            pre_existing_words.each do |word|
              file.puts word
            end
          end
        end

        it "must add the pre-existing words to the #unique_filter" do
          expect(pre_existing_words.all? { |word|
            subject.unique_filter.include?(word)
          }).to be(true)
        end

        after { ::FileUtils.rm_f(path) }
      end
    end
  end

  describe "#lexer" do
    it "must be a Lexer" do
      expect(subject.lexer).to be_kind_of(Wordlist::Lexer)
    end
  end

  describe "#unique_filter" do
    it "must be a UniqueFilter" do
      expect(subject.unique_filter).to be_kind_of(Wordlist::UniqueFilter)
    end
  end

  let(:added_words) { ::File.readlines(path).map(&:chomp) }

  before { ::FileUtils.rm_f(path) }

  describe "#add" do
    let(:word) { 'foo' }

    before do
      described_class.open(path) do |builder|
        builder.add(word)
      end
    end

    it "must add the word to the file" do
      expect(added_words).to eq([word])
    end

    context "when the same word is added multiple times" do
      before do
        described_class.open(path) do |builder|
          builder.add(word)
          builder.add(word)
        end
      end

      it "must filter out duplicate words" do
        expect(File.readlines(path).map(&:chomp)).to eq([word])
      end
    end
  end

  describe "#append" do
    let(:words) { %w[foo bar baz] }

    before do
      described_class.open(path) do |builder|
        builder.append(words)
      end
    end

    it "must add the words to the file" do
      expect(added_words).to eq(words)
    end

    context "when there are duplicate words in the given Array" do
      let(:words) { %w[foo bar bar baz] }

      it "must filter out duplicate words" do
        expect(added_words).to eq(words.uniq)
      end
    end
  end

  describe "#parse" do
    let(:words) { %w[foo bar baz] }
    let(:text)  { "foo bar, baz." }

    before do
      described_class.open(path) do |builder|
        builder.parse(text)
      end
    end

    it "must parse the text into words and add them to the file" do
      expect(added_words).to eq(words)
    end

    context "when the text contains duplicate words" do
      let(:text)  { "foo bar bar, baz baz." }

      it "must filter out duplicate words" do
        expect(added_words).to eq(words)
      end
    end
  end

  describe "#parse_file" do
    let(:text_file) { ::File.join(fixtures_dir,'text_file.txt') }

    let(:words) { %w[foo bar baz] }
    let(:text)  { "foo bar, baz." }

    before do
      ::File.write(text_file,text)

      described_class.open(path) do |builder|
        builder.parse(text)
      end
    end

    it "must parse the text file into words and add them to the file" do
      expect(added_words).to eq(words)
    end

    context "when the text file contains duplicate words" do
      let(:text)  { "foo bar bar, baz baz." }

      it "must filter out duplicate words" do
        expect(added_words).to eq(words)
      end
    end

    after { ::FileUtils.rm_f(text_file) }
  end

  describe "#close" do
    let(:word) { 'foo' }

    it "must close the wordlist file" do
      expect(::File.file?(path)).to be(false)

      subject.add(word)
      subject.close

      expect(::File.file?(path)).to be(true)
      expect(::File.size(path)).to be > 0
    end

    it "must clear the unique filter" do
      expect(subject.unique_filter).to be_empty
    end
  end

  describe "#closed?" do
    context "when the builder was been initialized" do
      it "must return false" do
        expect(subject.closed?).to be(false)
      end
    end

    context "when #close has been called" do
      before { subject.close }

      it "must return true" do
        expect(subject.closed?).to be(true)
      end
    end
  end

  after { ::FileUtils.rm_f(path) }
end
