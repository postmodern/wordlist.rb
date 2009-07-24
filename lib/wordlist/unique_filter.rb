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
    # Returns +true+ if the _word_ has been previously seen, returns
    # +false+ otherwise.
    #
    def seen?(word)
      length = word.length

      return (@seen.has_key?(length) && @seen[length].include?(crc32(word)))
    end

    #
    # Marks the specified _word_ as seen and returns +true+. If the _word_
    # has been previously been seen, +false+ will be returned.
    #
    def saw!(word)
      length = word.length
      crc = crc32(word)

      if @seen.has_key?(length)
        return false if @seen[length].include?(crc)
        @seen[length] << crc
      else
        @seen[length] = [crc]
      end

      return true
    end

    #
    # Passes the specified _word_ through the unique filter, if the
    # _word_ has not yet been seen, it will be passed to the given _block_.
    #
    def pass(word,&block)
      if saw!(word)
        block.call(word)
      end

      return nil
    end

    protected

    #
    # Returns the CRC32 checksum of the specified _word_.
    #
    def crc32(word)
      r = 0xffffffff

      word.each_byte do |b|
        r ^= b
        8.times { r = ((r >> 1) ^ (0xEDB88320 * (r & 1))) }
      end

      return r ^ 0xffffffff
    end

  end
end
