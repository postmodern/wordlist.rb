module Wordlist
  class AbstractList

    include Enumerable

    #
    # Place holder method.
    #
    # @abstract
    #
    def each(&block)
      raise(NotImplementedError,"#{self.class}#each was not implemented")
    end

  end
end
