require 'wordlist/operators/binary_operator'
require 'wordlist/unique_filter'

module Wordlist
  module Operators
    class Subtract < BinaryOperator

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
