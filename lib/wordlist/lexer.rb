# frozen_string_literal: true
require 'wordlist/lexer/lang'
require 'wordlist/lexer/stop_words'

require 'strscan'

module Wordlist
  #
  # Parses arbitrary text and scans each word from it.
  #
  # @api semipublic
  #
  # @since 1.0.0
  #
  class Lexer

    # Regexp to match acronyms.
    ACRONYM = /[[:alpha:]](?:\.[[:alpha:]])+\./

    # Default set of punctuation characters allowed within words
    SPECIAL_CHARS = %w[_ - ']

    # @return [Symbol]
    attr_reader :lang

    # @return [Array<String>]
    attr_reader :stop_words

    # @return [Array<String, Regexp>]
    attr_reader :ignore_words

    # @return [Array<String>]
    attr_reader :special_chars

    #
    # Initializes the lexer.
    #
    # @param [Symbol] lang
    #   The language to use. Defaults to {Lang.default}.
    #
    # @param [Array<String>] stop_words
    #   The explicit stop-words to ignore. If not given, default stop words
    #   will be loaded based on `lang` or {Lang.default}.
    #
    # @param [Array<String, Regexp>] ignore_words
    #   Optional list of words to ignore. Can contain Strings or Regexps.
    #
    # @param [Boolean] digits
    #   Controls whether parsed words may contain digits or not.
    #
    # @param [Array<String>] special_chars
    #   The additional special characters allowed within words.
    #
    # @param [Boolean] numbers
    #   Controls whether whole numbers will be parsed as words.
    #
    # @param [Boolean] acronyms
    #   Controls whether acronyms will be parsed as words.
    #
    # @param [Boolean] normalize_case
    #   Controls whether to convert all words to lowercase.
    #
    # @param [Boolean] normalize_apostrophes
    #   Controls whether apostrophes will be removed from the end of words.
    #
    # @param [Boolean] normalize_acronyms
    #   Controls whether acronyms will have `.` characters removed.
    #
    # @raise [ArgumentError]
    #   The `ignore_words` keyword contained a value other than a String or
    #   Regexp.
    #
    def initialize(lang:          Lang.default,
                   stop_words:    StopWords[lang],
                   ignore_words:  [],
                   digits:   true,
                   special_chars:  SPECIAL_CHARS,
                   numbers:  false,
                   acronyms: true,
                   normalize_case:        false,
                   normalize_apostrophes: false,
                   normalize_acronyms:    false)
      @lang          = lang
      @stop_words    = stop_words
      @ignore_words  = ignore_words
      @special_chars = special_chars

      @digits   = digits
      @numbers  = numbers
      @acronyms = acronyms

      @normalize_acronyms    = normalize_acronyms
      @normalize_apostrophes = normalize_apostrophes
      @normalize_case        = normalize_case

      escaped_chars = Regexp.escape(@special_chars.join)

      @word = if @digits
                # allows numeric characters
                /[[:alpha:]](?:[[:alnum:]#{escaped_chars}]*[[:alnum:]])?/
              else
                # only allows alpha characters
                /[[:alpha:]](?:[[:alpha:]#{escaped_chars}]*[[:alpha:]])?/
              end

      skip_words = Regexp.union(
        (@stop_words + @ignore_words).map { |pattern|
          case pattern
          when Regexp then pattern
          when String then /#{Regexp.escape(pattern)}/i
          else
            raise(ArgumentError,"ignore_words: must contain only Strings or Regexps")
          end
        }
      )

      if @numbers
        # allows lexing whole numbers
        @skip_word   = /(?:#{skip_words}[[:punct:]]*(?:[[:space:]]+|$))+/i
        @word        = /#{@word}|\d+/
        @not_a_word  = /[[:space:][:punct:]]+/
      else
        # skips whole numbers
        @skip_word   = /(?:(?:#{skip_words}|\d+)[[:punct:]]*(?:[[:space:]]+|$))+/i
        @not_a_word  = /[[:space:]\d[:punct:]]+/
      end
    end

    #
    # Determines whether parsed words may contain digits or not.
    #
    # @return [Boolean]
    #
    def digits?
      @digits
    end

    #
    # Determines whether numbers will be parsed or ignored.
    #
    # @return [Boolean]
    #
    def numbers?
      @numbers
    end

    #
    # Determines whether acronyms will be parsed or ignored.
    #
    # @return [Boolean]
    #
    def acronyms?
      @acronyms
    end

    #
    # Determines whether `.` characters will be removed from acronyms.
    #
    # @return [Boolean]
    #
    def normalize_acronyms?
      @normalize_acronyms
    end

    #
    # Determines whether apostrophes will be stripped from words.
    #
    # @return [Boolean]
    #
    def normalize_apostrophes?
      @normalize_apostrophes
    end

    #
    # Determines whether all words will be converted to lowercase.
    #
    # @return [Boolean]
    #
    def normalize_case?
      @normalize_case
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
    def parse(text,&block)
      return enum_for(__method__,text).to_a unless block_given?

      scanner = StringScanner.new(text)

      until scanner.eos?
        scanner.skip(@not_a_word)
        scanner.skip(@skip_word)

        if (acronym = scanner.scan(ACRONYM))
          if @acronyms
            acronym.tr!('.','') if @normalize_acronyms

            yield acronym
          end
        elsif (word = scanner.scan(@word))
          word.downcase! if @normalize_case
          word.chomp!("'s") if (@normalize_apostrophes && word.end_with?("'s"))

          yield word
        end
      end
    end

  end
end
