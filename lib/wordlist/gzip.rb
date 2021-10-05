require 'wordlist/compressed_wordlist'

module Wordlist
  #
  # Represents a wordlist that has been compressed with gzip.
  #
  #     wordlist = Wordlist::GZip.new("rockyou.txt.gz")
  #     wordlist.each do |word|
  #       puts word
  #     end
  #
  # @note
  #   The wordlist is read using the `zcat` utility, which is faster than
  #   decompressing the file using Ruby.
  #
  # @api public
  #
  class GZip < CompressedWordlist

    command 'zcat'

  end
end
