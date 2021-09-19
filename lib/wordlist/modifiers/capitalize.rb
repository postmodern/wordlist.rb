require 'wordlist/modifiers/modifier'

module Wordlist
  module Modifiers
    #
    # Calls `String#capitalize` on every word in the wordlist.
    #
    class Capitalize < Modifier

      def each
        return enum_for(__method__) unless block_given?

        @wordlist.each do |word|
          yield word.capitalize
        end
      end

    end
  end
end
