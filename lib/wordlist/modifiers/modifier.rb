module Wordlist
  module Modifiers
    class Modifier

      include Enumerable

      #
      # Initializes the modifier.
      #
      # @param [Enumerable] wordlist
      #   The wordlist to modify.
      #
      def initialize(wordlist)
        @wordlist = wordlist
      end

      #
      # Enumerates over every modification of every word in the wordlist.
      #
      # @yield [word]
      #
      # @yieldparam [String] word
      #
      # @return [Enumerator]
      #
      # @abstract
      #
      def each(&block)
        raise(NotImplementedError,"#{self.class}##{__method__} was not implemented")
      end

    end
  end
end
