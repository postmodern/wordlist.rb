# frozen_string_literal: true
require 'wordlist/abstract_wordlist'
require 'wordlist/exceptions'
require 'wordlist/format'
require 'wordlist/compression/reader'

module Wordlist
  #
  # Represents a `.txt` file wordlist.
  #
  #     wordlist = Wordlist::File.new("rockyou.txt")
  #     wordlist.each do |word|
  #       puts word
  #     end
  #
  # @api public
  #
  # @since 1.0.0
  #
  class File < AbstractWordlist

    # The path to the `.txt` file
    attr_reader :path

    # The format of the wordlist file.
    #
    # @return [:txt, :gzip, :bzip2, :xz, :zip]
    attr_reader :format

    #
    # Opens a wordlist file.
    #
    # @param [String] path
    #   The path to the `.txt` file wordlist read from.
    #
    # @param [:txt, :gz, :bzip2, :xz, :zip, nil] format
    #   The format of the wordlist. If not given the format will be inferred
    #   from the file extension.
    #
    # @raise [WordlistNotFound]
    #   The given path does not exist.
    #
    # @raise [UnknownFormat]
    #   The format could not be inferred from the file extension.
    #
    # @api public
    #
    def initialize(path, format: Format.infer(path))
      @path   = ::File.expand_path(path)
      @format = format

      unless ::File.file?(@path)
        raise(WordlistNotFound,"wordlist file does not exist: #{@path.inspect}")
      end

      unless Format::FORMATS.include?(@format)
        raise(UnknownFormat,"unknown format given: #{@format.inspect}")
      end
    end

    #
    # Opens a wordlist file.
    #
    # @param [String] path
    #   The path to the `.txt` file wordlist read from.
    #
    # @yield [wordlist]
    #   If a block is given, it will be passed the opened wordlist.
    #
    # @yieldparam [File] wordlist
    #   The newly opened wordlist.
    #
    # @return [File]
    #   The newly opened wordlist.
    #
    # @see #initialize
    #
    # @api public
    #
    def self.open(path,**kwargs)
      wordlist = new(path,**kwargs)
      yield wordlist if block_given?
      return wordlist
    end

    #
    # Opens and reads the wordlist file.
    #
    # @param [String] path
    #   The path to the `.txt` file wordlist read from.
    #
    # @yield [word]
    #   The given block will be passed every word from the wordlist.
    #
    # @yieldparam [String] word
    #   A word from the wordlist.
    #
    # @return [Enumerator]
    #   If no block is given, an Enumerator object will be returned.
    #
    def self.read(path,**kwargs,&block)
      open(path,**kwargs).each(&block)
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
    # @return [Enumerator]
    #   If no block is given, an Enumerator object will be returned.
    #
    # @api semipublic
    #
    def each_line(&block)
      return enum_for(__method__) unless block

      open { |io| io.each_line(&block) }
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
    # @return [Enumerator]
    #   If no block is given, an Enumerator object will be returned.
    #
    # @note
    #   Empty lines and lines beginning with `#` characters will be ignored.
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

    private

    #
    # Opens the wordlist for reading.
    #
    # @yield [io]
    #
    # @yieldparam [IO] io
    #
    def open(&block)
      if @format == :txt
        ::File.open(@path,&block)
      else
        Compression::Reader.open(@path, format: @format, &block)
      end
    end

  end
end
