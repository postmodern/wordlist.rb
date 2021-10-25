require 'spec_helper'
require 'wordlist/lexer'

describe Wordlist::Lexer do
  let(:text) { "foo bar baz qux" }

  it do
    expect(described_class).to include(Enumerable)
  end

  describe "#initialize" do
    let(:default_lang) { described_class.default_lang }

    it "must default #lang to self.class.default_lang" do
      expect(subject.lang).to eq(default_lang)
    end

    it "must set #stop_words to the stop words for :en" do
      expect(subject.stop_words).to eq(Wordlist::Lexer::StopWords[default_lang])
    end

    context "when the lang: keyword is given" do
      let(:lang) { :es }

      subject { described_class.new(lang: lang) }

      it "must set #lang" do
        expect(subject.lang).to eq(lang)
      end

      it "must set #stop_words to the stop words for that language" do
        expect(subject.stop_words).to eq(Wordlist::Lexer::StopWords[lang])
      end
    end
  end

  describe ".default_lang" do
    subject { described_class }

    context "when LANG is set" do
      context "and is of the form xx" do
        let(:env) { {'LANG' => 'xx'} }

        before { stub_const('ENV', env) }

        it "must return xx as a Symbol" do
          expect(subject.default_lang).to be(:xx)
        end
      end

      context "and is of the form xx_YY" do
        let(:env) { {'LANG' => 'xx_YY'} }

        before { stub_const('ENV', env) }

        it "must return xx as a Symbol" do
          expect(subject.default_lang).to be(:xx)
        end
      end

      context "and is of the form xx_YY.UTF-8" do
        let(:env) { {'LANG' => 'xx_YY.UTF-8'} }

        before { stub_const('ENV', env) }

        it "must return xx as a Symbol" do
          expect(subject.default_lang).to be(:xx)
        end
      end
    end

    context "when LANG is not set" do
      let(:env) { {} }

      before { stub_const('ENV', env) }

      it "must return :en" do
        expect(subject.default_lang).to be(:en)
      end
    end
  end

  describe "#parse" do
    let(:expected_words) { %w[foo bar baz qux] }
    let(:text) { expected_words.join(' ') }

    context "when a block is given" do
      it "must yield each scanned word from the text" do
        expect { |b|
          subject.parse(text,&b)
        }.to yield_successive_args(*expected_words)
      end

      context "when the text contains newlines" do
        let(:text) { expected_words.join("\n") }

        it "must parse each line" do
          expect { |b|
            subject.parse(text,&b)
          }.to yield_successive_args(*expected_words)
        end
      end

      context "when the text contains punctuation" do
        let(:text) { expected_words.join(", ") + '.' }

        it "must ignore all punctuation" do
          expect { |b|
            subject.parse(text,&b)
          }.to yield_successive_args(*expected_words)
        end

        context "and the words contain '-' characters" do
          let(:expected_words) { %w[foo bar baz qux] }
          let(:text) { "foo-bar baz-qux" }

          it "must split the words containing a '-'" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end
        end

        context "and the words contain '_' characters" do
          let(:expected_words) { %w[foo_bar baz_qux] }

          it "must treat the words containing a '_' as a single word" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end
        end
      end

      context "when the text contains digits" do
        let(:text) { expected_words.join(" 1234 ") }

        it "must ignore any numbers" do
          expect { |b|
            subject.parse(text,&b)
          }.to yield_successive_args(*expected_words)
        end

        context "but the text also contains words that end in digits" do
          let(:expected_words) { %w[foo1 bar2 baz3qux] }

          it "must not ignore the digits within words" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end
        end

        context "but the text also contains words that start with digits" do
          let(:text) { expected_words.map { |word| "123#{word}" }.join(' ') }

          it "must ignore the leading digits of words" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end
        end
      end

      context "when the text contains new-lines" do
        let(:text) { expected_words.join($/) }

        it "must ignore new-line characters" do
          expect { |b|
            subject.parse(text,&b)
          }.to yield_successive_args(*expected_words)
        end
      end

      context "when the text contains stop-words" do
        let(:stop_words) { %w[a the is be] }
        let(:text)       { expected_words.zip(stop_words).flatten.join(' ') }
        
        it "must ignore the stop-words and parse the non-stop-words" do
          expect { |b|
            subject.parse(text,&b)
          }.to yield_successive_args(*expected_words)
        end

        context "when the text contains multiple successive stop-words" do
          let(:text) { (stop_words + expected_words).join(' ') }
        
          it "must ignore multiple successive stop-words" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end
        end
      end
    end

    context "when no block is given" do
      it "must return an Array of the parsed words" do
        expect(subject.parse(text)).to eq(expected_words)
      end
    end
  end
end
