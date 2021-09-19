require 'wordlist/operators/binary_operator'

module Wordlist
  module Operators
    class Concat < BinaryOperator

      #
      # Ennumerables over each word in both wordlists.
      #
      # @yield [word]
      #   The given block will be passed each word from both wordlists.
      #
      # @yieldparam [String] word
      #   A word from one of the wordlists.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      def each(&block)
        return enum_for(__method__) unless block

        @left.each(&block)
        @right.each(&block)
      end

    end
  end
end
