require 'wordlist/txt'

require 'shellwords'

module Wordlist
  #
  # Represents a wordlist that has been compressed with gzip.
  #
  #     wordlist = Wordlist::GZip.new("rockyou.txt.gz")
  #     wordlist.each do |word|
  #       puts word
  #     end
  #
  class GZip < TXT

    #
    # Enumerates over each line in the gziped wordlist.
    #
    # @yield [line]
    #   The given block will be passed each line from the gziped wordlist.
    #
    # @yieldparam [String] line
    #   A newline terminated line from the gziped wordlist.
    #
    # @note
    #   The wordlist is read using the `zcat` utility, which is faster than
    #   decompressing the file using Ruby.
    #
    # @api semipublic
    #
    def each_line(&block)
      return enum_for(__method__) unless block

      IO.popen("zcat #{Shellwords.shellescape(path)}") do |io|
        io.each_line(&block)
      end
    end

  end
end
