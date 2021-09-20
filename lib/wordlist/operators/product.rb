require 'wordlist/operators/binary_operator'

module Wordlist
  module Operators
    class Product < BinaryOperator

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
