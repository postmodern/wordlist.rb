require 'wordlist/operators'
require 'wordlist/modifiers'

module Wordlist
  module ListMethods
    #
    # @group Operators
    #

    #
    # Lazily enumerates over the first wordlist, then the second.
    #
    # @param [Enumerable] other
    #   The other wordlist to concat.
    #
    # @return [Operators::Concat]
    #   The lazily concatinated wordlists.
    #
    # @example
    #   wordlist1 = Wordlist::List["foo", "bar", "baz"]
    #   wordlist2 = Wordlist::List["abc", "xyz"]
    #   (wordlist1 + wordlist2).each do |word|
    #     puts word
    #   end
    #   # foo
    #   # bar
    #   # baz
    #   # abc
    #   # xyz
    #
    # @api public
    #
    def concat(other)
      Operators::Concat.new(self,other)
    end

    alias + concat

    #
    # Lazily enumerates over every word in the first wordlist, that is not in
    # the second wordlist.
    #
    # @param [Enumerable] other
    #   The other wordlist to subtract.
    #
    # @return [Operators::Subtract]
    #   The lazy subtraction of the two wordlists.
    #
    # @example
    #   wordlist1 = Wordlist::List["foo", "bar", baz", "qux"]
    #   wordlist2 = Wordlist::List["bar", "qux"]
    #   (wordlist1 - wordlist2).each do |word|
    #     puts word
    #   end
    #   # foo
    #   # baz
    #
    # @api public
    #
    def subtract(other)
      Operators::Subtract.new(self,other)
    end

    alias - subtract

    #
    # Lazily enumerates over the combination of the words from two wordlists.
    #
    # @param [Enumerable] other
    #   The other wordlist to combine with.
    #
    # @return [Operators::Product]
    #   The lazy product of the two wordlists.
    #
    # @example
    #   wordlist1 = Wordlist::List["foo", "bar"]
    #   wordlist2 = Wordlist::List["ABC", "XYZ"]
    #   (wordlist1 * wordlist2).each do |word|
    #     puts word
    #   end
    #   # fooABC
    #   # fooXYZ
    #   # barABC
    #   # barXYZ
    #
    # @api public
    #
    def product(other)
      Operators::Product.new(self,other)
    end

    alias * product

    #
    # Lazily enumerates over every combination of words in the wordlist.
    #
    # @param [Integer] exponent
    #   The number of times the wordlist will be combined with itself.
    #
    # @return [Operators::Power]
    #   The lazy combination of the wordlist.
    #
    # @example
    #   wordlist = Wordlist::List["foo", "bar"]
    #   (wordlist ** 3).each do |word|
    #     puts word
    #   end
    #   # foofoofoo
    #   # foofoobar
    #   # foobarfoo
    #   # foobarbar
    #   # barfoofoo
    #   # barfoobar
    #   # barbarfoo
    #   # barbarbar
    #
    # @api public
    #
    def power(exponent)
      Operators::Power.new(self,exponent)
    end

    alias ** power

    #
    # Lazily enumerates over every word that belongs to both wordlists.
    #
    # @param [Enumerable] other
    #   The other wordlist to intersect with.
    #
    # @return [Operators::Intersect]
    #   The lazy intersection of the two wordlists.
    #
    # @example
    #   wordlist1 = Wordlist::List["foo", "bar", "baz", "qux"]
    #   wordlist2 = Wordlist::List["xyz", "bar", "abc", "qux"]
    #   (wordlist1 & wordlist2).each do |word|
    #     puts word
    #   end
    #   # bar
    #   # qux
    #
    # @api public
    #
    def intersect(other)
      Operators::Intersect.new(self,other)
    end

    alias & intersect

    #
    # Lazily enumerates over words from both wordlists, filtering out any
    # duplicates.
    #
    # @param [Enumerable] other
    #   The other wordlist to union with.
    #
    # @return [Operators::Union]
    #   The lazy union of the two wordlists.
    #
    # @example
    #   wordlist1 = Wordlist::List["foo", "bar", "baz", "qux"]
    #   wordlist2 = Wordlist::List["xyz", "bar", "abc", "qux"]
    #   (wordlist1 | wordlist2).each do |word|
    #     puts word
    #   end
    #   # foo
    #   # bar
    #   # baz
    #   # qux
    #   # xyz
    #   # abc
    #
    # @api public
    #
    def union(other)
      Operators::Union.new(self,other)
    end

    alias | union

    #
    #
    # Lazily enumerates over only the unique words in the wordlist, filtering
    # out duplicates.
    #
    # @return [Operators::Unique]
    #   The lazy uniqueness of the wordlist.
    #
    # @example
    #   wordlist= Wordlist::List["foo", "bar", "baz", "qux"]
    #   (wordlist + wordlist).uniq.each do |word|
    #     puts word
    #   end
    #   # foo
    #   # bar
    #   # baz
    #   # qux
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
    # @param [String] replace
    #   The characters or character range to use as the replacement.
    #
    # @return [Tr]
    #   The lazy `String#tr` modification of the wordlist.
    #
    # @example
    #   wordlist = Wordlist::List["foo", "bar", "baz"]
    #   wordlist.capitalize.each do |word|
    #     puts word
    #   end
    #   # Foo
    #   # Bar
    #   # Baz
    #
    # @api public
    #
    def tr(chars,replace)
      Modifiers::Tr.new(self,chars,replace)
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
    #   The lazy `String#sub` modification of the wordlist.
    #
    # @example
    #   wordlist = Wordlist::List["foo", "bar", "baz"]
    #   wordlist.sub(/o/, '0').each do |word|
    #     puts word
    #   end
    #   # f0o
    #   # bar
    #   # baz
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
    #   The lazy `String#gsub` modification of the wordlist.
    #
    # @example
    #   wordlist = Wordlist::List["Foo", "BAR", "bAz"]
    #   wordlist.gsub(/o/,'0').each do |word|
    #     puts word
    #   end
    #   # f00
    #   # bar
    #   # baz
    #
    # @api public
    #
    def gsub(pattern,replace=nil,&block)
      if replace
        Modifiers::Gsub.new(self,pattern,replace,&block)
      else
        Modifiers::Gsub.new(self,pattern,&block)
      end
    end

    #
    # Lazily calls `String#capitalize` on each word in the wordlist.
    #
    # @return [Capitalize]
    #   The lazy `String#gsub` modification of the wordlist.
    #
    # @example
    #   wordlist = Wordlist::List["foo", "bar", "baz"]
    #   wordlist.capitalize.each do |word|
    #     puts word
    #   end
    #   # Foo
    #   # Bar
    #   # Baz
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
    #   The lazy `String#gsub` modification of the wordlist.
    #
    # @example
    #   wordlist = Wordlist::List["foo", "bar", "baz"]
    #   wordlist.upcase.each do |word|
    #     puts word
    #   end
    #   # FOO
    #   # BAR
    #   # BAZ
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
    #   The lazy `String#gsub` modification of the wordlist.
    #
    # @example
    #   wordlist = Wordlist::List["Foo", "BAR", "bAz"]
    #   wordlist.downcase.each do |word|
    #     puts word
    #   end
    #   # foo
    #   # bar
    #   # baz
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
    #   The lazy `String#gsub` modification of the wordlist.
    #
    # @example
    #   wordlist = Wordlist::List["foo", "bar", "baz"]
    #   wordlist.mutate(/[oa]/, {'o' => '0', 'a' => '@'}).each do |word|
    #     puts word
    #   end
    #   # foo
    #   # f0o
    #   # fo0
    #   # f00
    #   # bar
    #   # b@r
    #   # baz
    #   # b@z
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
    #   The lazy `String#gsub` modification of the wordlist.
    #
    # @example
    #   wordlist = Wordlist::List["foo", "bar"]
    #   wordlist.mutate_case.each do |word|
    #     puts word
    #   end
    #  # foo
    #  # Foo
    #  # fOo
    #  # foO
    #  # FOo
    #  # FoO
    #  # fOO
    #  # FOO
    #  # bar
    #  # Bar
    #  # bAr
    #  # baR
    #  # BAr
    #  # BaR
    #  # bAR
    #  # BAR
    #
    # @api public
    #
    def mutate_case
      Modifiers::MutateCase.new(self)
    end
  end

  Operators::Operator.send :include, ListMethods
  Modifiers::Modifier.send :include, ListMethods
end
