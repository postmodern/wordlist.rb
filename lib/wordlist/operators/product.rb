require 'wordlist/operators/binary_operator'

module Wordlist
  module Operators
    #
    # Lazily enumerates over the combination of the words from two wordlists.
    #
    class Product < BinaryOperator

      #
      # Enumerates over every combination of the words from the two wordlist.
      #
      # @yield [string]
      #   The given block will be passed each combination of words from the
      #   two wordlist.
      #
      # @yieldparam [String] string
      #   A combination of two words from the two wordlists.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      # @example
      #   wordlist1 = Wordlist::List["foo", "bar"]
      #   wordlist2 = Wordlist::List["ABC", "XYZ"]
      #   (wordlist1 * wordlist2).each do |word|
      #     puts word
      #   end
      #   # fooABC
      #   # fooXYZ
      #   # barABC
      #   # barXYZ
      #
      # @api public
      #
      def each
        return enum_for(__method__) unless block_given?

        @left.each do |word1|
          @right.each do |word2|
            yield word1 + word2
          end
        end
      end

    end
  end
end
