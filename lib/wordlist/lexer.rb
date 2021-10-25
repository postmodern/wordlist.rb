require 'wordlist/lexer/stop_words'

require 'strscan'

module Wordlist
  #
  # Parses arbitrary text and scans each word from it.
  #
  class Lexer

    include Enumerable

    # Default regexp to match a single word.
    WORD = /[[:alpha:]][[:alnum:]_']+/

    # Skips whitespace, digits, punctuation, and symbols.
    NOT_A_WORD = /[^[:alpha:]]+/

    # The regexp for a word.
    #
    # @return [Regexp]
    attr_reader :word

    # @return [Symbol]
    attr_reader :lang

    # @return [Array<String>]
    attr_reader :stop_words

    #
    # Initializes the lexer.
    #
    # @param [Symbol] lang
    #   The language to use.
    #
    # @param [Array<String>, nil] stop_words
    #   The stop-words to ignore. If not given, will lookup the stop-words
    #   using {StopWords.[]} and the given `lang`.
    #
    def initialize(lang: self.class.default_lang, stop_words: nil)
      @lang       = lang
      @stop_words = stop_words || StopWords[lang]

      sorted_stop_words  = @stop_words.sort_by { |s| -s.length }
      escaped_stop_words = sorted_stop_words.map { |word|
                             Regexp.escape(word)
                           }.join('|')

      @skip_regexp = /(?:(?:#{escaped_stop_words}|\d+)(?:[^[:alnum:]]+|$))+/i
    end

    #
    # The default language.
    #
    # @return [Symbol]
    #
    def self.default_lang
      if (lang = ENV['LANG'])
        lang, encoding = lang.split('.',2)
        lang, country = lang.split('_',2)

        lang.to_sym
      else
        :en
      end
    end

    #
    # Enumerates over each word in the text.
    #
    # @yield [word]
    #   The given block will be passed each word from the text.
    #
    # @yieldparam [String] word
    #   A parsed word from the text.
    #
    # @return [Array<String>]
    #   If no block is given, an Array of the parsed words will be returned
    #   instead.
    #
    def parse(text)
      return enum_for(__method__,text).to_a unless block_given?

      scanner = StringScanner.new(text)

      until scanner.eos?
        scanner.skip(NOT_A_WORD)
        scanner.skip(@skip_regexp)

        if (word = scanner.scan(WORD))
          yield word
        end
      end
    end

  end
end
