require 'wordlist/compressed_wordlist'

module Wordlist
  #
  # Represents a wordlist that has been bziped.
  #
  #     wordlist = Wordlist::GZip.new("rockyou.txt.bz2")
  #     wordlist.each do |word|
  #       puts word
  #     end
  #
  # @note
  #   The wordlist is read using the `bzcat` utility, which is faster than
  #   decompressing the file using Ruby.
  #
  # @api public
  #
  class BZip2 < CompressedWordlist

    command 'bzcat'

  end
end
