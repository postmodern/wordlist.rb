require 'wordlist/compressed_wordlist'

require 'shellwords'

module Wordlist
  #
  # Represents a wordlist that has been compressed with `xz`.
  #
  #     wordlist = Wordlist::XZ.new("rockyou.txt.xz")
  #     wordlist.each do |word|
  #       puts word
  #     end
  #
  # @note
  #   The wordlist is read using the `xzcat` utility, which is faster than
  #   decompressing the file using Ruby.
  #
  # @api public
  #
  class XZ < CompressedWordlist

    command 'xzcat'

  end
end
