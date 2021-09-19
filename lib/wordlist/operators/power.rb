require 'wordlist/operators/binary_operator'

module Wordlist
  module Operators
    class Power < BinaryOperator

      def initialize(wordlist,exponent)
        super(wordlist,exponent)

        @wordlist = wordlist

        (right - 1).times do
          @wordlist *= wordlist
        end
      end

      def each(&block)
        @wordlist.each(&block)
      end

    end
  end
end
