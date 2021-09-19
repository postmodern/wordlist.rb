module Wordlist
  module ListMethods
    #
    # @group Operators
    #

    def concat(other)
      Operators::Concat.new(self,other)
    end

    alias + concat

    def subtract(other)
      Operators::Subtract.new(self,other)
    end

    alias - subtract

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
    def capitalize
      Modifiers::Capitalize.new(self)
    end

    #
    # Lazily calls `String#upcase` on each word in the wordlist.
    #
    # @return [Upcase]
    #
    def upcase
      Modifiers::Upcase.new(self)
    end

    #
    # Lazily calls `String#downcase` on each word in the wordlist.
    #
    # @return [Downcase]
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
    def each_case
      MutateCase.new(self)
    end
  end
end

require 'wordlist/operators'
require 'wordlist/modifiers'
