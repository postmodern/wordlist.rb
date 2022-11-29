# frozen_string_literal: true
require 'wordlist/operators/binary_operator'
require 'wordlist/unique_filter'

module Wordlist
  module Operators
    #
    # Lazily enumerates over words from both wordlists, filtering out any
    # duplicates.
    #
    # @since 1.0.0
    #
    class Union < BinaryOperator

      #
      # Enumerates over the union of the two wordlists.
      #
      # @yield [word]
      #   The given block will be passed each word from both wordlists,
      #   without duplicates.
      #
      # @yieldparam [String] word
      #   A word that belongs to one of the wordlists.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      # @example
      #   wordlist1 = Wordlist::Words["foo", "bar", "baz", "qux"]
      #   wordlist2 = Wordlist::Words["xyz", "bar", "abc", "qux"]
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
      def each
        return enum_for(__method__) unless block_given?

        unique_filter = UniqueFilter.new

        @left.each do |word|
          yield word
          unique_filter.add(word)
        end

        @right.each do |word|
          unless unique_filter.include?(word)
            yield word
          end
        end
      end

    end
  end
end
