require 'wordlist/runners/runner'

module Wordlist
  module Runners
    class List < Runner

      #
      # Creates a new List Runner.
      #
      def initialize
        @file = nil
        @min_length = nil
        @max_length = nil
        @mutations = []

        @words = false
        @unique_words = false
      end

      #
      # Runs the list runner with the given _args_.
      #
      def run(*args)
        super(*args)

        list = if @file
                 FlatFile.new(
                   @file,
                   :min_length => @min_length,
                   :max_length => @max_length
                 )
               else
                 print_error('the --file option must be specified')
                 exit -1
               end

        @mutations.each do |pattern,substitute|
          list.mutate(pattern,substitute)
        end

        if @unique_words
          list.each_unique(&output)
        elsif @words
          list.each_word(&output)
        else
          list.each(&output)
        end
      end

      protected

      #
      # Parses the given _args_.
      #
      def optparse(*args)
        super(*args) do |opts|
          opts.banner = 'usage: wordlist [options]'

          opts.on('-f','--file FILE','The wordlist file to list') do |file|
            @file = file
          end

          opts.on('--min-length NUM','Minimum length of words in characters') do |min|
            @min_length = min
          end

          opts.on('--max-length NUM','Maximum length of words in characters') do |max|
            @max_length = max
          end

          opts.on('-m','--mutate SUBSTRING::REPLACE','Adds a mutation rule') do |substring_and_replace|
            @mutations << substring_and_replace.split('::',2)
          end

          opts.on('-M','--mutate-pattern PATTERN::REPLACE','Adds a mutation rule') do |pattern_and_replace|
            pattern, replace = substring_and_replace.split('::',2)

            @mutations << [Regexp.new(pattern), replace]
          end

          opts.on('-w','--words','Only print the words in the wordlist') do
            @words = true
          end

          opts.on('-u','--unique','Only print the unique words in the wordlist') do
            @unique_words = true
          end
        end
      end

    end
  end
end
