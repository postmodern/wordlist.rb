require 'wordlist/abstract_list'

module Wordlist
  #
  # Represents a `.txt` file wordlist.
  #
  #     wordlist = Wordlist::TXT.new("rockyou.txt")
  #     wordlist.each do |word|
  #       puts word
  #     end
  #
  class TXT < AbstractList

    # The path to the `.txt` file
    attr_accessor :path

    #
    # Opens a new `.txt` file wordlist.
    #
    # @param [String] path
    #   The path to the `.txt` file wordlist read from.
    #
    # @param [Hash] options
    #   Additional options.
    #
    def initialize(path)
      @path = File.expand_path(path)
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
