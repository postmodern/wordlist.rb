require 'wordlist/operators/binary_operator'
require 'wordlist/unique_filter'

module Wordlist
  module Operators
    class Union < BinaryOperator

      #
      # @api public
      #
      def each
        return enum_for(__method__) unless block_given?

        unique_filter = UniqueFilter.new

        @left.each do |word|
          yield word
          unique_filter.add(word)
        end

        @right.each do |word|
          unless unique_filter.include?(word)
            yield word
          end
        end
      end

    end
  end
end
