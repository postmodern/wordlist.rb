# frozen_string_literal: true
require_relative 'binary_operator'
require_relative 'product'

module Wordlist
  module Operators
    #
    # Lazily enumerates over every combination of words in the wordlist.
    #
    # @since 1.0.0
    #
    class Power < BinaryOperator

      # The product of the wordlist with itself.
      #
      # @return [Product]
      attr_reader :wordlists

      alias exponent right

      #
      # Initializes the power operator.
      #
      # @param [Enumerable] wordlist
      #
      # @param [Integer] exponent
      #
      def initialize(wordlist,exponent)
        super(wordlist,exponent)

        @wordlists = wordlist

        (exponent - 1).times do
          @wordlists = Product.new(wordlist,@wordlists)
        end
      end

      #
      # Enumerates over every combination of words from the wordlist.
      #
      # @yield [string]
      #   The given block will be passed each combination of words from the
      #   wordlist.
      #
      # @yieldparam [String] string
      #   A combination of words from the wordlist.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      # @example
      #   wordlist = Wordlist::Words["foo", "bar"]
      #   (wordlist ** 3).each do |word|
      #     puts word
      #   end
      #   # foofoofoo
      #   # foofoobar
      #   # foobarfoo
      #   # foobarbar
      #   # barfoofoo
      #   # barfoobar
      #   # barbarfoo
      #   # barbarbar
      #
      # @api public
      #
      def each(&block)
        @wordlists.each(&block)
      end

    end
  end
end
