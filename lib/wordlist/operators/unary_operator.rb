require 'wordlist/operators/operator'

module Wordlist
  module Operators
    class UnaryOperator < Operator

      def initialize(wordlist)
        @wordlist = wordlist
      end

    end
  end
end
