require 'wordlist/operators/concat'
require 'wordlist/operators/product'
require 'wordlist/operators/power'
require 'wordlist/operators/intersect'
require 'wordlist/operators/union'

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

    def intersect(other)
      Operators::Intersect.new(self,exponent)
    end

    alias & intersect

    def union(other)
      Operators::Union.new(self,other)
    end

    alias | union

  end
end
