require 'wordlist/unique_filter'
require 'wordlist/parsers'

module Wordlist
  class Builder

    include Parsers

    # Path of the word-list
    attr_reader :path

    # Minimum number of words
    attr_reader :min_words

    # Maximum number of words
    attr_reader :max_words

    # File for the word-list
    attr_reader :file

    # The unique word filter
    attr_reader :filter

    # The queue of words awaiting processing
    attr_reader :word_queue

    #
    # Creates a new word-list Builder object with the specified _path_.
    # If a _block_ is given, it will be passed the newly created
    # Builder object.
    #
    def initialize(path,options={},&block)
      super()

      @path = File.expand_path(path)

      @min_words = (options[:min_words] || 1)
      @max_words = (options[:max_words] || @min_words)

      @file = nil
      @filter = UniqueFilter.new
      @word_queue = []

      block.call(self) if block
    end

    #
    # Creates a new Builder object with the given _arguments_, opens the
    # word-list file, passes the builder object to the given _block_
    # then finally closes the word-list file.
    #
    #   Builder.build('some/path') do |builder|
    #     builder.parse(readline)
    #   end
    #
    def self.build(*arguments,&block)
      self.new(*arguments) do |builder|
        builder.open!
        builder.build!(&block)
        builder.close!
      end
    end

    #
    # Opens the word-list file for writing. If the file already exists, the
    # previous words will be used to filter future duplicate words.
    #
    def open!
      if File.file?(@path)
        File.open(@path) do |file|
          file.each_line do |line|
            @filter.saw!(line.chomp)
          end
        end
      end

      @file = File.new(@path,File::RDWR | File::CREAT | File::APPEND)
    end

    #
    # Default to be called when the word-list is to be built, simply
    # calls the given _block_.
    #
    def build!(&block)
      block.call(self) if block
    end

    #
    # Enqueues the given _word_ for processing.
    #
    def enqueue(word)
      # enqueue the word
      if @max_words == 1
        @word_queue[0] = word.to_s
      else
        @word_queue << word.to_s

        # make sure the queue does not overflow
        if @word_queue.length > @max_words
          @word_queue.shift
        end
      end

      return word
    end

    #
    # Enumerates over the combinations of previously seen words,
    # passing each to the given _block_.
    #
    def word_combinations
      if @max_words == 1
        yield @word_queue[0]
      else
        current_words = @word_queue.length

        # we must have atleast the minimum amount of words
        if current_words >= @min_words
          upper_bound = (current_words - @min_words)

          # combine the words
          upper_bound.downto(0) do |i|
            yield @word_queue[i..-1].join(' ')
          end
        end
      end
    end

    #
    # Appends the specified _word_ to the word-list file, only if it has not
    # been previously seen.
    #
    def <<(word)
      enqueue(word)

      if @file
        word_combinations do |words|
          @filter.pass(words) do |unique|
            @file.puts unique
          end
        end
      end

      return self
    end

    #
    # Add the specified _words_ to the word-list.
    #
    def +(words)
      words.each { |word| self << word }
      return self
    end

    #
    # Parses the specified _text_ adding each unique word to the word-list
    # file.
    #
    def parse(text)
      super(text).each { |word| self << word }
    end

    #
    # Parses the contents of the file at the specified _path_, adding
    # each unique word to the word-list file.
    #
    def parse_file(path)
      File.open(path) do |file|
        file.each_line do |line|
          parse(line)
        end
      end
    end

    #
    # Closes the word-list file.
    #
    def close!
      if @file
        @file.close
        @file = nil

        @filter.clear
        @word_queue.clear
      end
    end

  end
end
