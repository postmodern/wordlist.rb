require 'set'

module Wordlist
  class UniqueFilter

    # The seen String hashes
    #
    # @return [Set<Integer>]
    attr_reader :hashes

    #
    # Creates a new unique filter.
    #
    def initialize
      @hashes = Set.new
    end

    #
    # Determines if the given word has been previously seen.
    #
    # @param [String] word
    #   The word to check for.
    #
    # @return [Boolean]
    #   Specifies whether the word has been previously seen.
    #
    def include?(word)
      @hashes.include?(word.hash)
    end

    #
    # Adds the word to the unique filter.
    #
    # @param [String] word
    #
    def add(word)
      @hashes.add(word.hash)
    end

    alias << add

    def add?(word)
      !@hashes.add?(word.hash).nil?
    end

  end
end
