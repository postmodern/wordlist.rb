# frozen_string_literal: true
require 'wordlist/modifiers/modifier'

module Wordlist
  module Modifiers
    #
    # Lazily calls `String#upcase` on every word in the wordlist.
    #
    # @since 1.0.0
    #
    class Upcase < Modifier

      #
      # Enumerates over every `upcase`d word in the wordlist.
      #
      # @yield [word]
      #   The given block will be passed each `upcase`d word.
      #
      # @yieldparam [String] word
      #   A `upcase`d word.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      # @example
      #   wordlist = Wordlist::Words["foo", "bar", "baz"]
      #   wordlist.upcase.each do |word|
      #     puts word
      #   end
      #   # FOO
      #   # BAR
      #   # BAZ
      #
      # @api public
      #
      def each
        return enum_for(__method__) unless block_given?

        @wordlist.each do |word|
          yield word.upcase
        end
      end

    end
  end
end
