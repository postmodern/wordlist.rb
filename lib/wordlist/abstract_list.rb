require 'wordlist/operations'
require 'wordlist/modifiers'

module Wordlist
  class AbstractList

    include Enumerable
    include Operations
    include Modifiers

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
