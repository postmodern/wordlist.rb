# frozen_string_literal: true
require 'wordlist/modifiers/sub'

module Wordlist
  module Modifiers
    #
    # Lazily calls `String#gsub` on every word in the wordlist.
    #
    # @since 1.0.0
    #
    class Gsub < Sub

      #
      # Enumerates over every `gsub`ed word in the wordlist.
      #
      # @yield [word]
      #   The given block will be passed each `gsub`ed word.
      #
      # @yieldparam [String] word
      #   A `gsub`ed word from the wordlist.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      # @example
      #   wordlist = Wordlist::Words["Foo", "BAR", "bAz"]
      #   wordlist.gsub(/o/,'0').each do |word|
      #     puts word
      #   end
      #   # f00
      #   # bar
      #   # baz
      #
      # @api public
      #
      def each
        return enum_for(__method__) unless block_given?

        if @replace
          @wordlist.each do |word|
            yield word.gsub(@pattern,@replace)
          end
        else
          @wordlist.each do |word|
            yield word.gsub(@pattern,&block)
          end
        end
      end

    end
  end
end
