module Wordlist
  module Parsers
    def self.included(base)
      base.module_eval do
        # Ignore case of parsed text
        attr_accessor :ignore_case

        # Ignore the punctuation of parsed text
        attr_accessor :ignore_punctuation

        # Ignore URLs
        attr_accessor :ignore_urls

        # Ignore Phone numbers
        attr_accessor :ignore_phone_numbers

        # Ignore References
        attr_accessor :ignore_references
      end
    end

    #
    # Initializes the parsers settings.
    #
    def initialize
      @ignore_case = false
      @ignore_punctuation = true
      @ignore_urls = true
      @ignore_phone_numbers = false
      @ignore_references = false
    end

    #
    # Parses the given text.
    #
    # @param [String] text
    #   The text to parse.
    #
    # @return [Array<String>]
    #   The Array of parsed tokens.
    #
    def parse(text)
      text = text.to_s

      if @ignore_punctuation
        # eat tailing punctuation
        text.gsub!(/[\.\?!]*$/,'')
      end

      if @ignore_case
        # downcase the sentence
        text.downcase!
      end

      if @ignore_urls
        text.gsub!(/\s*\w+:\/\/[\w\/\+_\-,:%\d\.\-\?&=]*\s*/,' ')
      end

      if @ignore_phone_numbers
        # remove phone numbers
        text.gsub!(/\s*(\d-)?(\d{3}-)?\d{3}-\d{4}\s*/,' ')
      end

      if @ignore_references
        # remove RFC style references
        text.gsub!(/\s*[\(\{\[]\d+[\)\}\]]\s*/,' ')
      end

      if @ignore_punctuation
        # split and ignore punctuation characters
        return text.scan(/\w+[\-_\.:']\w+|\w+/)
      else
        # split and accept punctuation characters
        return text.scan(/[\w\-_,:;\.\?\!'"\\\/]+/)
      end
    end
  end
end
