module Wordlist
  class UniqueFilter

    # CRC32 Hashes of words seen so far
    attr_reader :seen

    #
    # Creates a new UniqueFilter object.
    #
    def initialize
      @seen = []
    end

    #
    # Passes the specified _word_ through the unique filter, if the
    # _word_ has not yet been seen, it will be passed to the given _block_.
    #
    def pass(word,&block)
      crc = crc32(word)

      unless @seen.include?(crc)
        @seen << crc
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
