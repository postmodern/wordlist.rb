require 'wordlist/modifiers/tr'
require 'wordlist/modifiers/sub'
require 'wordlist/modifiers/gsub'
require 'wordlist/modifiers/capitalize'
require 'wordlist/modifiers/upcase'
require 'wordlist/modifiers/downcase'
require 'wordlist/modifiers/mutate'
require 'wordlist/modifiers/mutate_case'

module Wordlist
  module Modifiers
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
      Tr.new(self,pattern,replace)
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
        Sub.new(self,pattern,replace,&block)
      else
        Sub.new(self,pattern,&block)
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
        Gsub.new(self,pattern,replace,&block)
      else
        Gusb.new(self,pattern,&block)
      end
    end

    #
    # Lazily calls `String#capitalize` on each word in the wordlist.
    #
    # @return [Capitalize]
    #
    def capitalize
      Capitalize.new(self)
    end

    #
    # Lazily calls `String#upcase` on each word in the wordlist.
    #
    # @return [Upcase]
    #
    def upcase
      Upcase.new(self)
    end

    #
    # Lazily calls `String#downcase` on each word in the wordlist.
    #
    # @return [Downcase]
    #
    def downcase
      Downcase.new(self)
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
        Mutate.new(self,pattern,replace,&block)
      else
        Mutate.new(self,pattern,&block)
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
