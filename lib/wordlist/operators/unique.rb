# frozen_string_literal: true
require_relative 'unary_operator'
require_relative '../unique_filter'

module Wordlist
  module Operators
    #
    # Lazily enumerates over only the unique words in the wordlist, filtering
    # out duplicates.
    #
    # @since 1.0.0
    #
    class Unique < UnaryOperator

      #
      # Enumerates over the unique words in the wordlist.
      #
      # @yield [word]
      #   The given block will be passed each unique word from the wordlist.
      #
      # @yieldparam [String] word
      #   A unique word from the wordlist.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      # @example
      #   wordlist= Wordlist::Words["foo", "bar", "baz", "qux"]
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
      def each
        return enum_for(__method__) unless block_given?

        unique_filter = UniqueFilter.new

        @wordlist.each do |word|
          if unique_filter.add?(word)
            yield word
          end
        end
      end

    end
  end
end
