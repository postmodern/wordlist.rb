# frozen_string_literal: true
require 'wordlist/modifiers/mutate'

module Wordlist
  module Modifiers
    #
    # Lazily enumerates through every possible upper/lower-case variation of
    # each word in the wordlist.
    #
    # @since 1.0.0
    #
    class MutateCase < Mutate

      #
      # Initializes the case mutator.
      #
      # @param [Enumerable] wordlist
      #   The wordlist to modify.
      #
      def initialize(wordlist)
        super(wordlist,/[[:alpha:]]/) { |letter| letter.swapcase }
      end

    end
  end
end
