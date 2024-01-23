# frozen_string_literal: true
require_relative 'modifier'

module Wordlist
  module Modifiers
    #
    # Lazily calls `String#capitalize` on every word in the wordlist.
    #
    # @since 1.0.0
    #
    class Capitalize < Modifier

      #
      # Enumerates over every capitalized word in the wordlist.
      #
      # @yield [word]
      #   The given block will be passed each capitalized word.
      #
      # @yieldparam [String] word
      #   A capitalized word from the wordlist.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      # @example
      #   wordlist = Wordlist::Words["foo", "bar", "baz"]
      #   wordlist.capitalize.each do |word|
      #     puts word
      #   end
      #   # Foo
      #   # Bar
      #   # Baz
      #
      # @api public
      #
      def each
        return enum_for(__method__) unless block_given?

        @wordlist.each do |word|
          yield word.capitalize
        end
      end

    end
  end
end
