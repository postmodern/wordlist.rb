require 'wordlist/runners/runner'
require 'wordlist/flat_file'

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

        @output = nil
      end

      #
      # Runs the list runner.
      #
      # @param [Array<String>] args
      #   Arguments to run the runner with.
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

        words = lambda { |output|
          puts = output.method(:puts)

          if @unique_words
            list.each_unique(&puts)
          elsif @words
            list.each_word(&puts)
          else
            list.each(&puts)
          end
        }

        if @output
          File.open(@output,'w+',&words)
        else
          words.call(Kernel)
        end
      end

      protected

      #
      # Parses the given arguments.
      #
      # @param [Array<String>] args
      #   Arguments to parse.
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

          opts.on('-o','--output FILE','Optional file to output the wordlist to') do |file|
            @output = File.expand_path(file)
          end
        end
      end

    end
  end
end
