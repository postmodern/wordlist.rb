# frozen_string_literal: true
require_relative 'binary_operator'
require_relative '../unique_filter'

module Wordlist
  module Operators
    #
    # Lazily enumerates over every word that belongs to both wordlists.
    #
    # @since 1.0.0
    #
    class Intersect < BinaryOperator

      #
      # Enumerates over the intersection between two wordlists.
      #
      # @yield [word]
      #   The given block will be passed each word from the intersection between
      #   the two wordlists.
      #
      # @yieldparam [String] word
      #   A word that belongs to both wordlists.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      # @example
      #   wordlist1 = Wordlist::Words["foo", "bar", "baz", "qux"]
      #   wordlist2 = Wordlist::Words["xyz", "bar", "abc", "qux"]
      #   (wordlist1 & wordlist2).each do |word|
      #     puts word
      #   end
      #   # bar
      #   # qux
      #
      # @api public
      #
      def each
        return enum_for(__method__) unless block_given?

        unique_filter = UniqueFilter.new

        @left.each do |word|
          unique_filter.add(word)
        end

        @right.each do |word|
          if unique_filter.include?(word)
            yield word
          end
        end
      end

    end
  end
end
