require 'wordlist/operators/concat'
require 'wordlist/operators/product'

module Wordlist
  module Operations
    def concat(other)
      Operations::Concat.new(self,other)
    end

    alias + concat

    def product(other)
      Operations::Product.new(self,other)
    end

    alias * product
  end
end
