require 'wordlist/modifiers/modifier'

module Wordlist
  module Modifiers
    #
    # Lazily calls `String#upcase` on every word in the wordlist.
    #
    class Upcase < Modifier

      #
      # @api public
      #
      def each
        return enum_for(__method__) unless block_given?

        @wordlist.each do |word|
          yield word.upcase
        end
      end

    end
  end
end
