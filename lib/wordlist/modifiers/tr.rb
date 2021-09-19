require 'wordlist/modifiers/modifier'

module Wordlist
  module Modifiers
    #
    # Calls `String#tr` on every word in the wordlist.
    #
    class Tr < Modifier

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

      def each
        return enum_for(__method__) unless block_given?

        @wordlist.each do |word|
          yield word.tr(@chars,@replace)
        end
      end

    end
  end
end
