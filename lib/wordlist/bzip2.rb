require 'wordlist/txt'

require 'shellwords'

module Wordlist
  #
  # Represents a wordlist that has been bziped.
  #
  #     wordlist = Wordlist::GZip.new("rockyou.txt.bz2")
  #     wordlist.each do |word|
  #       puts word
  #     end
  #
  class BZip2 < TXT

    #
    # Enumerates over each line in the bziped wordlist.
    #
    # @yield [line]
    #   The given block will be passed each line from the bziped wordlist.
    #
    # @yieldparam [String] line
    #   A newline terminated line from the bziped wordlist.
    #
    # @note
    #   The wordlist is read using the `bzcat` utility, which is faster than
    #   decompressing the file using Ruby.
    #
    # @api semipublic
    #
    def each_line(&block)
      return enum_for(__method__) unless block

      IO.popen("bzcat #{Shellwords.shellescape(path)}") do |io|
        io.each_line(&block)
      end
    end

  end
end
