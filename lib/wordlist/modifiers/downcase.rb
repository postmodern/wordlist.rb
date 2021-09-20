require 'wordlist/modifiers/modifier'

module Wordlist
  module Modifiers
    #
    # Lazily calls `String#downcase` on every word in the wordlist.
    #
    class Downcase < Modifier

      def each
        return enum_for(__method__) unless block_given?

        @wordlist.each do |word|
          yield word.downcase
        end
      end

    end
  end
end
