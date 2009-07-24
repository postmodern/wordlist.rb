require 'wordlist/unique_filter'
require 'wordlist/parsers'

module Wordlist
  class Builder

    include Parsers

    # Path of the wordlist
    attr_reader :path

    # File for the wordlist
    attr_reader :file

    #
    # Creates a new wordlist Builder object with the specified _path_.
    # If a _block_ is given, it will be passed the newly created
    # Builder object.
    #
    def initialize(path,&block)
      super()

      @path = File.expand_path(path)
      @file = nil
      @filter = nil

      block.call(self) if block
    end

    #
    # Starts building a new wordlist at the specified _path_, passing
    # a new Builder object to the given _block_. After the given _block_
    # has returned, the wordlist will be closed.
    #
    #   Builder.build('some/path') do |builder|
    #     builder.parse_text(readline)
    #   end
    #
    def Builder.build(path,&block)
      self.new(path) do |builder|
        builder.open!

        block.call(builder)

        builder.close!
      end
    end

    #
    # Opens the wordlist file for writing. If the file already exists, the
    # previous words will be used to filter future duplicate words.
    #
    def open!
      @filter = UniqueFilter.new

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
    # Appends the specified _word_ to the wordlist file, only if it has not
    # been previously seen.
    #
    def <<(word)
      if @file
        @filter.pass(word) do |unique|
          @file.puts(unique)
        end
      end

      return self
    end

    #
    # Add the specified _words_ to the wordlist.
    #
    def +(words)
      words.each { |word| self << word }
      return self
    end

    #
    # Parses the specified _sentence_ adding each unique word to the
    # wordlist file.
    #
    def parse_sentence(sentence)
      super(sentence).each do |word|
        self << word
      end
    end

    #
    # Parses the specified _text_ adding each unique word to the wordlist
    # file.
    #
    def parse_text(text)
      super(text).each do |sentence|
        parse_sentence(sentence)
      end
    end

    #
    # Parses the contents of the file at the specified _path_, adding
    # each unique word to the wordlist file.
    #
    def parse_file(path)
      File.open(path) do |file|
        file.each_line do |line|
          parse_text(line)
        end
      end
    end

    #
    # Closes the wordlist file.
    #
    def close!
      if @file
        @file.close

        @file = nil
        @filter = nil
      end
    end

  end
end
