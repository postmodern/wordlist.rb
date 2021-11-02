require 'spec_helper'
require 'wordlist/lexer/stop_words'

describe Wordlist::Lexer::StopWords do
  describe "DIRECTORY" do
    subject { described_class::DIRECTORY }

    it "must exist" do
      expect(File.directory?(subject)).to be(true)
    end
  end

  describe ".path_for" do
    let(:lang) { :en }

    subject { described_class.path_for(lang) }

    it "must return the path to the .txt file in DIRECTORY" do
      expect(File.dirname(subject)).to eq(described_class::DIRECTORY)
      expect(File.basename(subject)).to eq("#{lang}.txt")
    end
  end

  describe ".read" do
    context "when given a supported language" do
      let(:lang) { :en }

      let(:expected_words) do
        File.readlines(subject.path_for(lang)).map(&:chomp)
      end

      it "must return the words in the .txt file for the language" do
        expect(subject.read(lang)).to eq(expected_words)
      end
    end

    context "when given an invalid language" do
      let(:lang) { :foo }

      it do
        expect {
          subject.read(lang)
        }.to raise_error(Wordlist::UnsupportedLanguage,"unsupported language: #{lang}")
      end
    end
  end

  describe ".[]" do
    context "when given a supported language" do
      let(:lang) { :en }

      let(:expected_words) do
        File.readlines(subject.path_for(lang)).map(&:chomp)
      end

      it "must return the words in the .txt file for the language" do
        expect(subject[lang]).to eq(expected_words)
      end

      context "when called multiple times" do
        it "must return the same cached stop words" do
          expect(subject[lang]).to be(subject[lang])
        end
      end
    end

    context "when given an invalid language" do
      let(:lang) { :foo }

      it do
        expect {
          subject[lang]
        }.to raise_error(Wordlist::UnsupportedLanguage,"unsupported language: #{lang}")
      end
    end
  end
end
