# frozen_string_literal: true
require 'wordlist/list_methods'

module Wordlist
  #
  # The base class for all wordlist classes.
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
