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

    it "must default #ignore_words to []" do
      expect(subject.ignore_words).to eq([])
    end

    it "must default #digits? to true" do
      expect(subject.digits?).to be(true)
    end

    it "must default #special_chars to SPECIAL_CHARS" do
      expect(subject.special_chars).to eq(described_class::SPECIAL_CHARS)
    end

    it "must default #numbers? to false" do
      expect(subject.numbers?).to be(false)
    end

    it "must default #acroynyms? to true" do
      expect(subject.acronyms?).to be(true)
    end

    it "must default #normalize_case? to false" do
      expect(subject.normalize_case?).to be(false)
    end

    it "must default #normalize_apostrophes? to false" do
      expect(subject.normalize_apostrophes?).to be(false)
    end

    it "must default #normalize_acroynyms? to false" do
      expect(subject.normalize_acronyms?).to be(false)
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

    context "when ignore_words: keyword argument is given" do
      let(:ignore_words) { %w[foo bar] }

      subject { described_class.new(ignore_words: ignore_words) }

      it "must set #ignore_words" do
        expect(subject.ignore_words).to eq(ignore_words)
      end

      context "and it contains an object other than a String or Regexp" do
        it do
          expect {
            described_class.new(ignore_words: [Object.new])
          }.to raise_error(ArgumentError,"ignore_words: must contain only Strings or Regexps")
        end
      end
    end

    context "when digits: false is given" do
      subject { described_class.new(digits: false) }

      it "must set #digits? to false" do
        expect(subject.digits?).to be(false)
      end
    end

    context "when special_chars: keyword is given" do
      let(:special_chars) { %w[_ -] }

      subject { described_class.new(special_chars: special_chars) }

      it "must set #special_chars" do
        expect(subject.special_chars).to eq(special_chars)
      end
    end

    context "when numbers: true is given" do
      subject { described_class.new(numbers: true) }

      it "must set #numbers? to true" do
        expect(subject.numbers?).to be(true)
      end
    end

    context "when acronyms: true is given" do
      subject { described_class.new(acronyms: true) }

      it "must set #acronyms? to true" do
        expect(subject.acronyms?).to be(true)
      end
    end

    context "when normalize_case: true is given" do
      subject { described_class.new(normalize_case: true) }

      it "must set #normalize_case? to true" do
        expect(subject.normalize_case?).to be(true)
      end
    end

    context "when normalize_apostrophes: true is given" do
      subject { described_class.new(normalize_apostrophes: true) }

      it "must set #normalize_apostrophes? to true" do
        expect(subject.normalize_apostrophes?).to be(true)
      end
    end

    context "when normalize_acronyms: true is given" do
      subject { described_class.new(normalize_acronyms: true) }

      it "must set #normalize_acronyms? to true" do
        expect(subject.normalize_acronyms?).to be(true)
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

      context "and is of the form C.UTF-8" do
        let(:env) { {'LANG' => 'C.UTF-8'} }

        before { stub_const('ENV', env) }

        it "must return :en" do
          expect(subject.default_lang).to be(:en)
        end
      end
    end

    context "when LANG is C" do
      let(:env) { {'LANG' => 'C'} }

      before { stub_const('ENV', env) }

      it "must default to :en" do
        expect(subject.default_lang).to be(:en)
      end
    end

    context "when LANG is not set" do
      let(:env) { {} }

      before { stub_const('ENV', env) }

      it "must default to :en" do
        expect(subject.default_lang).to be(:en)
      end
    end
  end

  describe "#parse" do
    let(:expected_words) { %w[foo bar baz qux]      }
    let(:text)           { expected_words.join(' ') }

    context "when a block is given" do
      it "must yield each scanned word from the text" do
        expect { |b|
          subject.parse(text,&b)
        }.to yield_successive_args(*expected_words)
      end

      context "when the words contain uppercase letters" do
        let(:expected_words) { %w[foo Bar baZ QUX] }

        it "must parse words containing uppercase letters" do
          expect { |b|
            subject.parse(text,&b)
          }.to yield_successive_args(*expected_words)
        end

        context "but when initialized with normalize_case: true" do
          let(:expected_words) { %w[foo bar baz qux] }
          let(:text)           { "foo Bar baZ QUX"   }

          subject { described_class.new(normalize_case: true) }

          it "must convert all words to lowercase" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end
        end
      end

      context "and when the text contains single letters" do
        let(:letters)        { %w[x y z]         }
        let(:expected_words) { super() + letters }

        it "must parse single letter words" do
          expect { |b|
            subject.parse(text,&b)
          }.to yield_successive_args(*expected_words)
        end

        context "when the text also contains single letter stop words" do
          let(:letters)        { %w[a b c i j k] }
          let(:stop_words)     { %w[a i]         }
          let(:expected_words) { super() - stop_words }
          let(:text)           { "#{super()} #{stop_words.join(' ')}" }

          it "must parse single letter words" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end
        end
      end

      context "and when the text contains newlines" do
        let(:text) { expected_words.join("\n") }

        it "must parse each line" do
          expect { |b|
            subject.parse(text,&b)
          }.to yield_successive_args(*expected_words)
        end
      end

      context "and when the text contains punctuation" do
        let(:text) { expected_words.join(", ") + '.' }

        it "must ignore all punctuation" do
          expect { |b|
            subject.parse(text,&b)
          }.to yield_successive_args(*expected_words)
        end

        context "and the words start with a '\\'' characters" do
          let(:expected_words) { %w[foo bar baz] }
          let(:text)           { "foo 'bar baz"  }

          it "must skip the leading '\\' character'" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end
        end

        context "and the words contain '\\'' characters" do
          let(:expected_words) { super() + %w[O'Brian] }

          it "must parse the words containing a '\\''" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end

          context "and when initialized with normalize_apostrophes: true" do
            let(:text)           { "foo bar's baz" }
            let(:expected_words) { %w[foo bar baz] }

            subject { described_class.new(normalize_apostrophes: true) }

            it "must remove any trailing \"'s\" from the words" do
              expect { |b|
                subject.parse(text,&b)
              }.to yield_successive_args(*expected_words)
            end
          end
        end

        context "and the words end with a '\\'' characters" do
          let(:expected_words) { %w[foo bar baz] }
          let(:text)           { "foo bar' baz"  }

          it "must skip the trailing '\\' character'" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end
        end

        context "and the words start with a '-' characters" do
          let(:expected_words) { %w[foo bar baz] }
          let(:text)           { "foo -bar baz"  }

          it "must skip the leading '-' character'" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end
        end

        context "and the words contain '-' characters" do
          let(:expected_words) { %w[foo-bar baz-qux] }

          it "must parse words containing a '-'" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end

          context "and when initialized with chars: keyword argument" do
            context "and it does not include '-'" do
              let(:text)           { "foo bar-baz qux"   }
              let(:expected_words) { %w[foo bar baz qux] }

              subject { described_class.new(special_chars: ['_']) }

              it "must split hyphenated words into multiple words" do
                expect { |b|
                  subject.parse(text,&b)
                }.to yield_successive_args(*expected_words)
              end
            end
          end
        end

        context "and the words end with a '-' characters" do
          let(:expected_words) { %w[foo bar baz] }
          let(:text)           { "foo bar- baz"  }

          it "must skip the trailing '-' character'" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end
        end

        context "and the words start with a '_' characters" do
          let(:expected_words) { %w[foo bar baz] }
          let(:text)           { "foo _bar baz"  }

          it "must skip the leading '_' character'" do
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

          context "and when initialized with chars: keyword argument" do
            context "and it does not include '_'" do
              let(:text)           { "foo bar_baz qux"   }
              let(:expected_words) { %w[foo bar baz qux] }

              subject { described_class.new(special_chars: ['-']) }

              it "must split hyphenated words into multiple words" do
                expect { |b|
                  subject.parse(text,&b)
                }.to yield_successive_args(*expected_words)
              end
            end
          end
        end

        context "and the words end with a '_' characters" do
          let(:expected_words) { %w[foo bar baz] }
          let(:text)           { "foo bar_ baz"  }

          it "must skip the trailing '_' character'" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end
        end

        context "and the words start with a '.' characters" do
          let(:expected_words) { %w[foo bar baz] }
          let(:text)           { "foo .bar baz"  }

          it "must skip the leading '.' character'" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end
        end

        context "and the words contain '.' characters" do
          let(:text)           { "foo.bar baz.qux"  }
          let(:expected_words) { %w[foo bar baz qux] }

          it "must split words containing '.' into multiple words" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end

          context "and when initialized with chars: keyword argument" do
            context "and it does include '.'" do
              let(:expected_words) { %w[foo.bar baz.qux] }

              subject { described_class.new(special_chars: ['.']) }

              it "must treat words containing a '.' as a single word" do
                expect { |b|
                  subject.parse(text,&b)
                }.to yield_successive_args(*expected_words)
              end
            end
          end
        end

        context "and the words end with a '.' characters" do
          let(:expected_words) { %w[foo bar baz] }
          let(:text)           { "foo bar. baz"  }

          it "must skip the trailing '.' character'" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end

          context "but the word is an acronym" do
            let(:expected_words) { %w[foo B.A.R. baz] }
            let(:text)           { "foo B.A.R. baz"  }

            it "must parse whole acronyms'" do
              expect { |b|
                subject.parse(text,&b)
              }.to yield_successive_args(*expected_words)
            end

            context "but was initialized with acronyms: false" do
              let(:expected_words) { %w[foo baz] }

              subject { described_class.new(acronyms: false) }

              it "must skip the whole acronyms" do
                expect { |b|
                  subject.parse(text,&b)
                }.to yield_successive_args(*expected_words)
              end
            end

            context "and when initialized with normalize_acronyms: true" do
              let(:expected_words) { %w[foo BAR baz] }
              let(:text)           { "foo B.A.R. baz"  }

              subject { described_class.new(normalize_acronyms: true) }

              it "must remove the '.' characters from acronyms" do
                expect { |b|
                  subject.parse(text,&b)
                }.to yield_successive_args(*expected_words)
              end
            end
          end
        end
      end

      context "and when the text contains numbers" do
        let(:text) { expected_words.join(" 1234 ") }

        it "must ignore whole numbers" do
          expect { |b|
            subject.parse(text,&b)
          }.to yield_successive_args(*expected_words)
        end

        context "when initialized with numbers: true" do
          let(:expected_words) { %w[foo 1234 bar 000 baz 0123] }
          let(:text)           { expected_words.join(' ')      }

          subject { described_class.new(numbers: true) }

          it "must parse whole numbers" do
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

        context "but the text also contains words that contain digits" do
          let(:expected_words) { %w[foo bar1baz qux] }

          it "must not ignore the digits within words" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end

          context "but when initialized with digits: false" do
            let(:expected_words) { %w[foo bar baz qux] }
            let(:text)           { "foo bar2baz qux"   }

            subject { described_class.new(digits: false) }

            it "must ignore the leading digits within words" do
              expect { |b|
                subject.parse(text,&b)
              }.to yield_successive_args(*expected_words)
            end
          end
        end

        context "but the text also contains words that end in digits" do
          let(:expected_words) { super().map { |word| "#{word}123" } }

          it "must not ignore the digits within words" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end

          context "but when initialized with digits: false" do
            let(:expected_words) { %w[foo bar baz qux] }
            let(:text)           { "foo bar2 baz qux4" }

            subject { described_class.new(digits: false) }

            it "must ignore the leading digits within words" do
              expect { |b|
                subject.parse(text,&b)
              }.to yield_successive_args(*expected_words)
            end
          end
        end
      end

      context "and when the text contains new-lines" do
        let(:text) { expected_words.join($/) }

        it "must ignore new-line characters" do
          expect { |b|
            subject.parse(text,&b)
          }.to yield_successive_args(*expected_words)
        end
      end

      context "and when the text contains stop-words" do
        let(:stop_words) { %w[a the is be] }
        let(:text)       { expected_words.zip(stop_words).flatten.join(' ') }
        
        it "must ignore the stop-words and parse the non-stop-words" do
          expect { |b|
            subject.parse(text,&b)
          }.to yield_successive_args(*expected_words)
        end

        context "and when the stop words are capitlized" do
          let(:stop_words) { super().map(&:capitalize) }

          it "must ignore the capitlized stop-words" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end
        end

        context "and when the stop words are uppercase" do
          let(:stop_words) { super().map(&:upcase) }

          it "must ignore the uppercase stop-words" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end
        end

        context "and when the text ends with a stop word" do
          let(:text) { "#{super()} is" }

          it "must ignore the last stop word" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end
        end

        context "and when a stop word is followed by other letters" do
          let(:stop_word)      { "be" }
          let(:expected_words) { super() + ["#{stop_word}tter"] }

          it "must not ignore stop words followed by other letters" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end
        end

        context "and when a stop word is followed by digits" do
          let(:stop_word)      { "a" }
          let(:expected_words) { super() + ["#{stop_word}1234"] }

          it "must not ignore stop words followed by digits" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end
        end

        context "and when a stop word is followed by punctuation" do
          let(:stop_words) { %w[is. be, the?] }

          it "must not ignore stop words followed by punctuation" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end
        end

        context "and when the text contains multiple successive stop-words" do
          let(:text) { (stop_words + expected_words).join(' ') }
        
          it "must ignore multiple successive stop-words" do
            expect { |b|
              subject.parse(text,&b)
            }.to yield_successive_args(*expected_words)
          end
        end
      end

      context "and when #ignore_words contains a String" do
        let(:ignore_words)   { %w[foo baz] }
        let(:expected_words) { %w[bar qux] }
        let(:text)           { "foo bar baz qux" }

        subject { described_class.new(ignore_words: ignore_words) }

        it "must filter out words matching that String" do
          expect { |b|
            subject.parse(text,&b)
          }.to yield_successive_args(*expected_words)
        end
      end

      context "and when #ignore_words contains a Regexp" do
        let(:ignore_words)   { [/ba[a-z]/] }
        let(:expected_words) { %w[foo qux] }
        let(:text)           { "foo bar baz qux" }

        subject { described_class.new(ignore_words: ignore_words) }

        it "must filter out words matching that Regexp" do
          expect { |b|
            subject.parse(text,&b)
          }.to yield_successive_args(*expected_words)
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
