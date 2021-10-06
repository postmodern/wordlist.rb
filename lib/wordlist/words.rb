require "wordlist/abstract_wordlist"

module Wordlist
  #
  # An in-memory wordlist of words.
  #
  #     Wordlist::Words["foo", "bar", "baz"]
  #
  # @api public
  #
  class Words < AbstractWordlist

    # The words in the wordlist.
    #
    # @return [Array<String>, Enumerable]
    attr_reader :words

    #
    # Creates a new wordlist object.
    #
    # @param [Array<String>, Enumerable] words
    #   The words for the wordlist.
    #
    # @api public
    #
    def initialize(words=[])
      @words = words
    end

    #
    # Creates a new wordlist from the given words.
    #
    # @param [Array<String>] words
    #   The words for the wordlist.
    #
    # @example
    #   Wordlist::Words["foo", "bar", "baz"]
    #
    # @api public
    #
    def self.[](*words)
      new(words)
    end

    #
    # Enumerate through every word in the in-memory wordlist.
    #
    # @yield [word]
    #   The given block will be passed each word in the list.
    #
    # @yieldparam [String] word
    #   A word from the in-memory wordlist.
    #
    # @return [Enumerator]
    #   If no block is given, then an `Enumerator` object will be returned.
    #
    # @example
    #   words.each do |word|
    #     puts word
    #   end
    #
    # @api public
    #
    def each(&block)
      @words.each(&block)
    end

  end
end
