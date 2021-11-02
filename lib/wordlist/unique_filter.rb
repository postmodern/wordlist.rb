require 'set'

module Wordlist
  #
  # Acts as a filter to filter out duplicate words.
  #
  # @since 1.0.0
  #
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
    #   The word to add.
    #
    def add(word)
      @hashes.add(word.hash)
    end

    alias << add

    #
    # Attempts to add the word to the unique filter.
    #
    # @param [String] word
    #   The word to add.
    #
    # @return [Boolean]
    #   Returns `true` if the word does not yet exist in the unique filter.
    #   Returns `false` if the word already exists in the unique filter.
    #
    def add?(word)
      !@hashes.add?(word.hash).nil?
    end

    #
    # Determines if the unique filter is empty or not.
    #
    # @return [Boolean]
    #
    def empty?
      @hashes.empty?
    end

    #
    # Clears the unique filter.
    #
    def clear
      @hashes.clear
    end

    #
    # The size of the unique filter.
    #
    # @return [Integer]
    #   The number of unique words seen by the unique filter.
    #
    def size
      @hashes.size
    end

  end
end
