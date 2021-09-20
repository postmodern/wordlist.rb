module Wordlist
  module Operators
    class Operator

      include Enumerable

      #
      # @abstract
      #
      def each(&block)
        raise(NotImplementedError,"#{self.class}#each was not implemented")
      end

    end
  end
end
