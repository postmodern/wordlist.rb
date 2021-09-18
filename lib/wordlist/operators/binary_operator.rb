require 'wordlist/operators/operator'

module Wordlist
  module Operators
    class BinaryOperator < Operator

      def initialize(left,right)
        @left  = left
        @right = right
      end

    end
  end
end
