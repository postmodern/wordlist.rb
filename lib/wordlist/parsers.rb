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

    def initialize
      @ignore_case = false
      @ignore_punctuation = false
      @ignore_urls = true
      @ignore_phone_numbers = false
      @ignore_references = false
    end

    #
    # Parses the specified _sentence_ and returns an Array of tokens.
    #
    def parse_sentence(sentence)
      sentence = sentence.to_s

      if @ignore_punctuation
        # eat tailing punctuation
        sentence.gsub!(/[\.\?!]*$/,'')
      end

      if @ignore_case
        # downcase the sentence
        sentence.downcase!
      end

      if @ignore_urls
        sentence.gsub!(/\s*\w+:\/\/[\w\/\+_\-,:%\d\.\-\?&=]*\s*/,' ')
      end

      if @ignore_phone_numbers
        # remove phone numbers
        sentence.gsub!(/\s*(\d-)?(\d{3}-)?\d{3}-\d{4}\s*/,' ')
      end

      if @ignore_references
        # remove RFC style references
        sentence.gsub!(/\s*[\(\{\[]\d+[\)\}\]]\s*/,' ')
      end

      if @ignore_punctuation
        # split and ignore punctuation characters
        return sentence.scan(/\w+[\-_\.:']\w+|\w+/)
      else
        # split and accept punctuation characters
        return sentence.scan(/[\w\-_,:;\.\?\!'"\\\/]+/)
      end
    end

    #
    # Parses the specified _text_ and returns an Array of sentences.
    #
    def parse_text(text)
      text = text.to_s

      if @ignore_urls
        text.gsub!(/\s*\w+:\/\/[\w\/\+_\-,:%\d\.\-\?&=]*\s*/,' ')
      end

      return text.scan(/[^\s\.\?!][^\.\?!]*[\.\?\!]/)
    end

  end
end
