require "wordlist/abstract_list"

module Wordlist
  #
  # An in-memory wordlist of words.
  #
  #     Wordlist::List["foo", "bar", "baz]
  #
  class List < AbstractList

    #
    # Creates a new wordlist object.
    #
    # @param [Array<String>, Enumerable] words
    #   The words for the wordlist.
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
    #   Wordlist::List["foo", "bar", "baz]
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
    #   list.each do |word|
    #     puts word
    #   end
    #
    def each(&block)
      @words.each(&block)
    end

  end
end
