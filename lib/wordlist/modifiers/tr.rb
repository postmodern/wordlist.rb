# frozen_string_literal: true
require 'wordlist/modifiers/modifier'

module Wordlist
  module Modifiers
    #
    # Lazily calls `String#tr` on every word in the wordlist.
    #
    # @since 1.0.0
    #
    class Tr < Modifier

      # The characters or character range to translate.
      #
      # @return [String]
      attr_reader :chars

      # The characters or character range to translate to.
      #
      # @return [String]
      attr_reader :replace

      #
      # Initializes the `String#tr` modifier.
      #
      # @param [String] chars
      #   The characters or character range to replace.
      #
      # @param [String] replace
      #   The characters or character range to use as the replacement.
      #
      def initialize(wordlist,chars,replace)
        super(wordlist)

        @chars   = chars
        @replace = replace
      end

      #
      # Enumerates over every `tr`ed word in the wordlist.
      #
      # @yield [word]
      #   The given block will be passed each `tr`ed word.
      #
      # @yieldparam [String] word
      #   A `tr`ed word.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      # @example
      #   wordlist = Wordlist::Words["foo", "bar", "baz"]
      #   wordlist.tr("oa", "0@").each do |word|
      #     puts word
      #   end
      #   # f00
      #   # b@r
      #   # b@z
      #
      # @api public
      #
      def each
        return enum_for(__method__) unless block_given?

        @wordlist.each do |word|
          yield word.tr(@chars,@replace)
        end
      end

    end
  end
end
