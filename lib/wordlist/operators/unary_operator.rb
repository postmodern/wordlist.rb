require 'wordlist/operators/operator'

module Wordlist
  module Operators
    #
    # Unary operator base class.
    #
    class UnaryOperator < Operator

      # The wordlist to operate on.
      #
      # @return [Enumerable]
      attr_reader :wordlist

      #
      # Initializes the unary operator.
      #
      # @param [Enumerable] wordlist
      #   The wordlist.
      #
      def initialize(wordlist)
        @wordlist = wordlist
      end

    end
  end
end
