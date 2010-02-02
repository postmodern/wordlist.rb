require 'wordlist/list'

module Wordlist
  class FlatFile < List

    # The path to the flat-file
    attr_accessor :path

    #
    # Opens a new FlatFile list.
    #
    # @param [String] path
    #   The path to the flat file word-list read from.
    #
    # @param [Hash] options
    #   Additional options.
    #
    def initialize(path,options={},&block)
      @path = path

      super(options,&block)
    end

    #
    # Enumerates through every word in the flat-file.
    #
    # @yield [word]
    #   The given block will be passed every word from the word-list.
    #
    # @yieldparam [String] word
    #   A word from the word-list.
    #
    # @example
    #   flat_file.each_word do |word|
    #     puts word
    #   end
    #
    def each_word(&block)
      File.open(@path) do |file|
        file.each_line do |line|
          yield line.chomp
        end
      end
    end

  end
end
