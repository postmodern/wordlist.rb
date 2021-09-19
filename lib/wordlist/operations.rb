require 'wordlist/operators/concat'
require 'wordlist/operators/product'
require 'wordlist/operators/power'

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

    def power(exponent)
      Operators::Power.new(self,exponent)
    end

    alias ** power

  end
end
