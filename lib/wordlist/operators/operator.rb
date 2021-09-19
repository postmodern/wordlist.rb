module Wordlist
  module Operators
    class Operator

      include Enumerable
      # include ListMethods

      def each(&block)
        raise(NotImplementedError,"#{self.class}#each was not implemented")
      end

    end
  end
end
