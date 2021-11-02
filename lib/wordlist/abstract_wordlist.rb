require 'wordlist/list_methods'

module Wordlist
  #
  # @since 1.0.0
  #
  class AbstractWordlist

    include Enumerable
    include ListMethods

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
