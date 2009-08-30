require 'wordlist/list'

module Wordlist
  module Formats
    class FlatFile < List

      # The path to the flat-file
      attr_accessor :path

      #
      # Creates a new FlatFile list with the specified _path_ and given
      # _options_.
      #
      def initialize(path,options={})
        @path = path

        super(options)
      end

      #
      # Enumerates through every word in the flat-file, passing each
      # word to the given _block_.
      #
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
end
