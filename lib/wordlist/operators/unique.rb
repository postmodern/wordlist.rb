require 'wordlist/operators/unary_operator'
require 'wordlist/unique_filter'

module Wordlist
  module Operators
    class Unique < UnaryOperator

      def each
        return enum_for(__method__) unless block_given?

        unique_filter = UniqueFilter.new

        @wordlist.each do |word|
          if unique_filter.add?(word)
            yield word
          end
        end
      end

    end
  end
end
