module Wordlist
  module Operators
    class Operator

      include Enumerable

      def each(&block)
        raise(NotImplementedError,"#{self.class}#each was not implemented")
      end

    end
  end
end
