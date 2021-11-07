require 'wordlist/operators/binary_operator'

module Wordlist
  module Operators
    #
    # Lazily enumerates over the first wordlist, then the second.
    #
    # @since 1.0.0
    #
    class Concat < BinaryOperator

      #
      # Enumerates over each word in both wordlists.
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
      # @example
      #   wordlist1 = Wordlist::Words["foo", "bar", "baz"]
      #   wordlist2 = Wordlist::Words["abc", "xyz"]
      #   (wordlist1 + wordlist2).each do |word|
      #     puts word
      #   end
      #   # foo
      #   # bar
      #   # baz
      #   # abc
      #   # xyz
      #
      # @api public
      #
      def each(&block)
        return enum_for(__method__) unless block

        @left.each(&block)
        @right.each(&block)
      end

    end
  end
end
