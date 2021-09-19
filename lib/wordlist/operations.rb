require 'wordlist/operators/concat'
require 'wordlist/operators/product'

module Wordlist
  module Operations
    def concat(other)
      Operators::Concat.new(self,other)
    end

    alias + concat

    def product(other)
      Operators::Product.new(self,other)
    end

    alias * product
  end
end
