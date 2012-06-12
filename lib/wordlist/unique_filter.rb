require 'set'

module Wordlist
  class UniqueFilter

    # CRC32 Hashes of words seen so far
    attr_reader :seen

    #
    # Creates a new UniqueFilter object.
    #
    def initialize
      @seen = {}
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
    def seen?(word)
      length = word.length

      (@seen.has_key?(length) && @seen[length].include?(crc32(word)))
    end

    #
    # Marks the given word as previously seen.
    #
    # @param [String] word
    #   The word to mark as previously seen.
    #
    # @return [Boolean]
    #   Specifies whether or not the word has not been previously seen
    #   until now.
    #
    def saw!(word)
      length = word.length
      crc    = crc32(word)

      if @seen.has_key?(length)
        return false if @seen[length].include?(crc)
        @seen[length] << crc
      else
        @seen[length] = SortedSet[crc]
      end

      return true
    end

    #
    # Passes the given word through the unique filter.
    #
    # @param [String] word
    #   The word to pass through the unique filter.
    #
    # @yield [word]
    #   The given block will be passed the word, if the word has not been
    #   previously seen by the filter.
    #
    # @yieldparam [String] word
    #   A unique word that has not been previously seen by the filter.
    #
    # @return [nil]
    #
    def pass(word)
      if saw!(word)
        yield word
      end

      return nil
    end

    #
    # Clears the unique filter.
    #
    # @return [UniqueFilter]
    #   The cleared filter.
    #
    def clear
      @seen.clear
      return self
    end

    protected

    #
    # Returns the CRC32 checksum of the given word.
    #
    # @param [String] word
    #   The word to calculate a CRC32 checksum for.
    #
    # @return [Integer]
    #   The CRC32 checksum for the given word.
    #
    def crc32(word)
      r = 0xffffffff

      word.each_byte do |b|
        r ^= b
        8.times { r = ((r >> 1) ^ (0xEDB88320 * (r & 1))) }
      end

      r ^ 0xffffffff
    end

  end
end
