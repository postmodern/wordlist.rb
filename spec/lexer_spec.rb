require 'spec_helper'
require 'wordlist/lexer'

describe Wordlist::Lexer do
  let(:text) { "foo bar baz qux" }

  it do
    expect(described_class).to include(Enumerable)
  end

  describe "#initialize" do
  end

  describe "#each" do
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
    end

    context "when no block is given" do
      it "must return an Array of the parsed words" do
        expect(subject.parse(text)).to eq(expected_words)
      end
    end
  end
end
