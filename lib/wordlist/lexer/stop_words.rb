# frozen_string_literal: true
require_relative '../exceptions'

module Wordlist
  class Lexer
    #
    # Stop words for various languages.
    #
    # @api semipublic
    #
    # @since 1.0.0
    #
    module StopWords
      # The directory containing the stop words `.txt` files.
      DIRECTORY = ::File.expand_path(::File.join(__dir__,'..','..','..','data','stop_words'))

      #
      # The path to the stop words `.txt` file.
      #
      # @param [Symbol] lang
      #   The language to load.
      #
      # @return [String]
      #
      def self.path_for(lang)
        ::File.join(DIRECTORY,"#{lang}.txt")
      end

      #
      # Reads the stop words.
      #
      # @param [Symbol] lang
      #   The language to load.
      #
      # @return [Array<String>]
      #
      # @raise [UnsupportedLanguage]
      #
      def self.read(lang)
        path = path_for(lang)

        unless ::File.file?(path)
          raise(UnsupportedLanguage,"unsupported language: #{lang}")
        end

        lines = ::File.readlines(path)
        lines.each(&:chomp!)
        lines
      end

      @stop_words = {}
      @mutex = Mutex.new

      #
      # Lazy loads the stop words for the given language.
      #
      # @param [Symbol] lang
      #   The language to load.
      #
      # @return [Array<String>]
      #
      def self.[](lang)
        @mutex.synchronize do
          @stop_words[lang] ||= read(lang)
        end
      end
    end
  end
end
