require 'wordlist/operators'
require 'wordlist/modifiers'

module Wordlist
  module ListMethods
    #
    # @group Operators
    #

    #
    # @api public
    #
    def concat(other)
      Operators::Concat.new(self,other)
    end

    alias + concat

    #
    # @api public
    #
    def subtract(other)
      Operators::Subtract.new(self,other)
    end

    alias - subtract

    #
    # @api public
    #
    def product(other)
      Operators::Product.new(self,other)
    end

    alias * product

    #
    # @api public
    #
    def power(exponent)
      Operators::Power.new(self,exponent)
    end

    alias ** power

    #
    # @api public
    #
    def intersect(other)
      Operators::Intersect.new(self,exponent)
    end

    alias & intersect

    #
    # @api public
    #
    def union(other)
      Operators::Union.new(self,other)
    end

    alias | union

    #
    # @api public
    #
    def uniq
      Operators::Unique.new(self)
    end

    #
    # @group Modifiers
    #

    #
    # Lazily calls `String#tr` on each word in the wordlist.
    #
    # @param [String] chars
    #   The characters or character range to replace.
    #
    # @param [String] replacement
    #   The characters or character range to use as the replacement.
    #
    # @return [Tr]
    #
    # @api public
    #
    def tr(pattern,replace)
      Modifiers::Tr.new(self,pattern,replace)
    end

    #
    # Lazily calls `String#sub` on each word in the wordlist.
    #
    # @param [Regexp, String] pattern
    #   The pattern to replace.
    #
    # @param [String, Hash, nil] replace
    #   The characters or character range to use as the replacement.
    #
    # @yield [match]
    #   The given block will be call to replace the matched substring,
    #   if `replace` is nil.
    #
    # @yieldparam [String] match
    #   A matched substring.
    #
    # @return [Sub]
    #
    # @api public
    #
    def sub(pattern,replace=nil,&block)
      if replace
        Modifiers::Sub.new(self,pattern,replace,&block)
      else
        Modifiers::Sub.new(self,pattern,&block)
      end
    end

    #
    # Lazily calls `String#gsub` on each word in the wordlist.
    #
    # @param [Regexp, String] pattern
    #   The pattern to replace.
    #
    # @param [String, Hash, nil] replace
    #   The characters or character range to use as the replacement.
    #
    # @yield [match]
    #   The given block will be call to replace the matched substring,
    #   if `replace` is nil.
    #
    # @yieldparam [String] match
    #   A matched substring.
    #
    # @return [Gsub]
    #
    # @api public
    #
    def gsub(pattern,replace=nil,&block)
      if replace
        Modifiers::Gsub.new(self,pattern,replace,&block)
      else
        Modifiers::Gusb.new(self,pattern,&block)
      end
    end

    #
    # Lazily calls `String#capitalize` on each word in the wordlist.
    #
    # @return [Capitalize]
    #
    # @api public
    #
    def capitalize
      Modifiers::Capitalize.new(self)
    end

    #
    # Lazily calls `String#upcase` on each word in the wordlist.
    #
    # @return [Upcase]
    #
    # @api public
    #
    def upcase
      Modifiers::Upcase.new(self)
    end

    #
    # Lazily calls `String#downcase` on each word in the wordlist.
    #
    # @return [Downcase]
    #
    # @api public
    #
    def downcase
      Modifiers::Downcase.new(self)
    end

    #
    # Lazily performs every combination of a string substitution on every word
    # in the wordlist.
    #
    # @param [Regexp, String] pattern
    #   The pattern to replace.
    #
    # @param [String, Hash, nil] replace
    #   The characters or character range to use as the replacement.
    #
    # @yield [match]
    #   The given block will be call to replace the matched substring,
    #   if `replace` is nil.
    #
    # @yieldparam [String] match
    #   A matched substring.
    #
    # @return [Mutate]
    #
    # @api public
    #
    def mutate(pattern,replace=nil,&block)
      if replace
        Modifiers::Mutate.new(self,pattern,replace,&block)
      else
        Modifiers::Mutate.new(self,pattern,&block)
      end
    end

    #
    # Lazily enumerates over every uppercase/lowercase variation of the word.
    #
    # @return [EachCase]
    #
    # @api public
    #
    def each_case
      MutateCase.new(self)
    end
  end

  Operators::Operator.send :include, ListMethods
  Modifiers::Modifier.send :include, ListMethods
end
