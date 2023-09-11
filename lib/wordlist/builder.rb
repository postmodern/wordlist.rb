# frozen_string_literal: true
require 'wordlist/format'
require 'wordlist/lexer'
require 'wordlist/unique_filter'
require 'wordlist/file'
require 'wordlist/compression/writer'

module Wordlist
  #
  # Parses text and builds a wordlist file.
  #
  # @api public
  #
  # @since 1.0.0
  #
  class Builder

    # Path of the wordlist
    #
    # @return [String]
    attr_reader :path

    # The format of the wordlist file.
    #
    # @return [:txt, :gzip, :bzip2, :xz, :zip, :7zip]
    attr_reader :format

    # The word lexer.
    #
    # @return [Lexer]
    attr_reader :lexer

    # The unique filter.
    #
    # @return [UniqueFilter]
    attr_reader :unique_filter

    #
    # Creates a new word-list Builder object.
    #
    # @param [String] path
    #   The path of the wordlist file.
    #
    # @param [:txt, :gz, :bzip2, :xz, :zip, :7zip, nil] format
    #   The format of the wordlist. If not given the format will be inferred
    #   from the file extension.
    #
    # @param [Boolean] append
    #   Indicates whether new words will be appended to the wordlist or
    #   overwrite the wordlist.
    #
    # @param [Hash{Symbol => Object}] kwargs
    #   Additional keyword arguments for {Lexer#initialize}.
    #
    # @option kwargs [Symbol] :lang
    #   The language to use. Defaults to {Lexer::Lang.default}.
    #
    # @option kwargs [Array<String>] :stop_words
    #   The explicit stop-words to ignore. If not given, default stop words
    #   will be loaded based on `lang` or {Lexer::Lang.default}.
    #
    # @option kwargs [Array<String, Regexp>] :ignore_words
    #   Optional list of words to ignore. Can contain Strings or Regexps.
    #
    # @option kwargs [Boolean] :digits (true)
    #   Controls whether parsed words may contain digits or not.
    #
    # @option kwargs [Array<String>] :special_chars (Lexer::SPCIAL_CHARS)
    #   The additional special characters allowed within words.
    #
    # @option kwargs [Boolean] :numbers (false)
    #   Controls whether whole numbers will be parsed as words.
    #
    # @option kwargs [Boolean] :acronyms (true)
    #   Controls whether acronyms will be parsed as words.
    #
    # @option kwargs [Boolean] :normalize_case (false)
    #   Controls whether to convert all words to lowercase.
    #
    # @option kwargs [Boolean] :normalize_apostrophes (false)
    #   Controls whether apostrophes will be removed from the end of words.
    #
    # @option kwargs [Boolean] :normalize_acronyms (false)
    #   Controls whether acronyms will have `.` characters removed.
    #
    # @raise [ArgumentError]
    #   The format could not be inferred from the file extension, or the
    #   `ignore_words` keyword contained a value other than a String or Regexp.
    #
    def initialize(path, format: Format.infer(path), append: false, **kwargs)
      @path   = ::File.expand_path(path)
      @format = format
      @append = append

      @lexer = Lexer.new(**kwargs)
      @unique_filter = UniqueFilter.new

      load! if append? && ::File.file?(@path)
      open!
    end

    #
    # Creates a new Builder object with the given arguments, opens the
    # word-list file, passes the builder object to the given block
    # then finally closes the word-list file.
    #
    # @param [String] path
    #   The path of the wordlist file.
    #
    # @yield [builder]
    #   If a block is given, it will be passed the new builder.
    #
    # @yieldparam [self] builder
    #   The newly created builder object.
    #
    # @return [Builder]
    #   The newly created builder object.
    #
    # @example
    #   Builder.open('path/to/file.txt') do |builder|
    #     builder.parse(text)
    #   end
    #
    def self.open(path,**kwargs)
      builder = new(path,**kwargs)

      if block_given?
        begin
          yield builder
        ensure
          builder.close
        end
      end

      return builder
    end

    #
    # Determines if the builder will append new words to the existing wordlist
    # or overwrite it.
    #
    # @return [Boolean]
    #
    def append?
      @append
    end

    #
    # Writes a comment line to the wordlist file.
    #
    # @param [String] message
    #   The comment message to write.
    #
    def comment(message)
      write("# #{message}")
    end

    #
    # Appends the given word to the wordlist file, only if it has not
    # been previously added.
    #
    # @param [String] word
    #   The word to append.
    #
    # @return [self]
    #   The builder object.
    #
    def add(word)
      if @unique_filter.add?(word)
        write(word)
      end

      return self
    end

    alias << add
    alias push add

    #
    # Add the given words to the word-list.
    #
    # @param [Array<String>] words
    #   The words to add to the list.
    #
    # @return [self]
    #   The builder object.
    #
    def append(words)
      words.each { |word| add(word) }
      return self
    end

    alias concat append

    #
    # Parses the given text, adding each unique word to the word-list file.
    #
    # @param [String] text
    #   The text to parse.
    #
    def parse(text)
      @lexer.parse(text) do |word|
        add(word)
      end
    end

    #
    # Parses the contents of the file at the given path, adding each unique
    # word to the word-list file.
    #
    # @param [String] path
    #   The path of the file to parse.
    #
    def parse_file(path)
      ::File.open(path) do |file|
        file.each_line do |line|
          parse(line)
        end
      end
    end

    #
    # Closes the word-list file.
    #
    def close
      unless @io.closed?
        @io.close
        @unique_filter.clear
      end
    end

    #
    # Indicates whether the wordlist builder has been closed.
    #
    # @return [Boolean]
    #
    def closed?
      @io.closed?
    end

    private

    # 
    # Prepopulates the builder with the existing wordlist's content.
    #
    def load!
      Wordlist::File.read(@path) do |word|
        @unique_filter << word
      end
    end

    #
    # Writes a line to the wordlist file.
    #
    # @param [String] line
    #   The line to write.
    #
    # @abstract
    #
    def write(line)
      @io.puts(line)
      @io.flush
    end

    #
    # Opens the wordlist file.
    #
    def open!
      if @format == :txt
        mode = if append? then 'a'
               else            'w'
               end

        @io = ::File.open(@path,mode)
      else
        @io = Compression::Writer.open(@path, format: @format, append: append?)
      end
    end

  end
end
