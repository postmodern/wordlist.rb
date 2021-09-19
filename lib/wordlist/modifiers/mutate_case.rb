require 'wordlist/modifiers/mutate'

module Wordlist
  module Modifiers
    class MutateCase < Mutate

      def initialize(wordlist)
        super(wordlist,/[[:alpha:]]/) { |letter| letter.swapcase }
      end

    end
  end
end
