require 'wordlist/operators/binary_operator'
require 'wordlist/operators/product'

module Wordlist
  module Operators
    class Power < BinaryOperator

      # The product of the wordlist with itself.
      #
      # @return [Product]
      attr_reader :wordlists

      alias exponent right

      #
      # Initializes the power operator.
      #
      # @param [Enumerable] wordlist
      #
      # @param [Integer] exponent
      #
      def initialize(wordlist,exponent)
        super(wordlist,exponent)

        @wordlists = wordlist

        (exponent - 1).times do
          @wordlists = Product.new(wordlist,@wordlists)
        end
      end

      #
      # @api public
      #
      def each(&block)
        @wordlists.each(&block)
      end

    end
  end
end
