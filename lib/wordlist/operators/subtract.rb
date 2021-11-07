require 'wordlist/operators/binary_operator'
require 'wordlist/unique_filter'

module Wordlist
  module Operators
    #
    # Lazily enumerates over every word in the first wordlist, that is not in
    # the second wordlist.
    #
    # @since 1.0.0
    #
    class Subtract < BinaryOperator

      #
      # Enumerates over the difference between the two wordlists.
      #
      # @yield [word]
      #   The given block will be passed each word from the first wordlist,
      #   that is not in the second wordlist.
      #
      # @yieldparam [String] word
      #   A word that belongs to first wordlist, but not the second wordlist.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      # @example
      #   wordlist1 = Wordlist::Words["foo", "bar", baz", "qux"]
      #   wordlist2 = Wordlist::Words["bar", "qux"]
      #   (wordlist1 - wordlist2).each do |word|
      #     puts word
      #   end
      #   # foo
      #   # baz
      #
      # @api public
      #
      def each
        return enum_for(__method__) unless block_given?

        unique_filter = UniqueFilter.new

        @right.each { |word| unique_filter.add(word) }

        @left.each do |word|
          unless unique_filter.include?(word)
            yield word
          end
        end
      end

    end
  end
end
