module Wordlist
  module Operators
    class Concat

      include Enumerable

      def initialize(left,right)
        @left  = left
        @right = right
      end

      def each(&block)
        @left.each(&block)
        @right.each(&block)
      end

    end
  end
end
