require 'wordlist/txt'

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
  # @api public
  #
  class XZ < TXT

    #
    # Enumerates over each line in the xz compressed wordlist.
    #
    # @yield [line]
    #   The given block will be passed each line from the xz compressed
    #   wordlist.
    #
    # @yieldparam [String] line
    #   A newline terminated line from the xz compressed wordlist.
    #
    # @note
    #   The wordlist is read using the `xzcat` utility, which is faster than
    #   decompressing the file using Ruby.
    #
    # @api semipublic
    #
    def each_line(&block)
      return enum_for(__method__) unless block

      IO.popen("xzcat #{Shellwords.shellescape(path)}") do |io|
        io.each_line(&block)
      end
    end

  end
end
