require 'wordlist/abstract_wordlist'

module Wordlist
  #
  # Represents a `.txt` file wordlist.
  #
  #     wordlist = Wordlist::TXT.new("rockyou.txt")
  #     wordlist.each do |word|
  #       puts word
  #     end
  #
  # @api public
  #
  class TXT < AbstractWordlist

    # The path to the `.txt` file
    attr_reader :path

    #
    # Opens a new `.txt` file wordlist.
    #
    # @param [String] path
    #   The path to the `.txt` file wordlist read from.
    #
    # @api public
    #
    def initialize(path)
      @path = File.expand_path(path)
    end

    #
    # Opens a wordlist file.
    #
    # @param [String] path
    #   The path to the `.txt` file wordlist read from.
    #
    # @return [self]
    #   The newly opened wordlist.
    #
    # @see #initialize
    #
    # @api public
    #
    def self.open(path)
      new(path)
    end

    #
    # Enumerates through each line in the `.txt` file wordlist.
    #
    # @yield [line]
    #   The given block will be passed each line from the `.txt` file.
    #
    # @yieldparam [String] line
    #   A newline terminated line from the file.
    #
    # @api semipublic
    #
    def each_line(&block)
      return enum_for(__method__) unless block

      File.open(@path) do |file|
        file.each_line(&block)
      end
    end

    #
    # Enumerates through every word in the `.txt` file.
    #
    # @yield [word]
    #   The given block will be passed every word from the wordlist.
    #
    # @yieldparam [String] word
    #   A word from the wordlist.
    #
    # @note
    #   Empty lines and lines betweening with `#` characters will be ignored.
    #
    # @example
    #   wordlist.each do |word|
    #     puts word
    #   end
    #
    # @api public
    #
    def each
      return enum_for(__method__) unless block_given?

      each_line do |line|
        line.chomp!

        unless (line.empty? || line.start_with?('#'))
          yield line
        end
      end
    end

  end
end
