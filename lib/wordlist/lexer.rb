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
    SKIP = /[^[:alpha:]]+/

    # The regexp for a word.
    #
    # @return [Regexp]
    attr_reader :word

    #
    # Initializes the lexer.
    #
    def initialize
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
        if (word = scanner.scan(WORD))
          yield word
        else
          scanner.skip(SKIP)
        end
      end
    end

  end
end
