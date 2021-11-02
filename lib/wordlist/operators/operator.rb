module Wordlist
  module Operators
    #
    # Operator base class.
    #
    class Operator

      include Enumerable

      #
      # Place-holder method.
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
        raise(NotImplementedError,"#{self.class}#each was not implemented")
      end

    end
  end
end
