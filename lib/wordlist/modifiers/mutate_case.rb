require 'wordlist/modifiers/mutate'

module Wordlist
  module Modifiers
    #
    # Lazily enumerates through every possible upper/lower-case variation of
    # each word in the wordlist.
    #
    class MutateCase < Mutate

      def initialize(wordlist)
        super(wordlist,/[[:alpha:]]/) { |letter| letter.swapcase }
      end

    end
  end
end
