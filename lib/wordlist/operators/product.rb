require 'wordlist/operators/binary_operator'

module Wordlist
  module Operators
    class Product < BinaryOperator

      def each(&block)
        @left.each do |word1|
          @right.each do |word2|
            yield word1 + word2
          end
        end
      end

    end
  end
end
