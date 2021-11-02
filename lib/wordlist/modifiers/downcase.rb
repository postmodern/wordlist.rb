require 'wordlist/modifiers/modifier'

module Wordlist
  module Modifiers
    #
    # Lazily calls `String#downcase` on every word in the wordlist.
    #
    # @since 1.0.0
    #
    class Downcase < Modifier

      #
      # Enumerates over every `downcase`d word in the wordlist.
      #
      # @yield [word]
      #   The given block will be passed each `downcase`d word.
      #
      # @yieldparam [String] word
      #   A `downcase`d word.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      # @example
      #   wordlist = Wordlist::List["Foo", "BAR", "bAz"]
      #   wordlist.downcase.each do |word|
      #     puts word
      #   end
      #   # foo
      #   # bar
      #   # baz
      #
      # @api public
      #
      def each
        return enum_for(__method__) unless block_given?

        @wordlist.each do |word|
          yield word.downcase
        end
      end

    end
  end
end
