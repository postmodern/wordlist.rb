require 'wordlist/modifiers/modifier'

module Wordlist
  module Modifiers
    #
    # Lazily calls `String#tr` on every word in the wordlist.
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
