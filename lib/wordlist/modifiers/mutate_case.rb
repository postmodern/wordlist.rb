require 'wordlist/modifiers/mutator'

module Wordlist
  module Modifiers
    class MutateCase < Mutator

      def initialize(wordlist)
        super(wordlist,/[[:alpha:]]/) { |letter| letter.swapcase }
      end

    end
  end
end
