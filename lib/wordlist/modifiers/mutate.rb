# frozen_string_literal: true
require_relative 'sub'

module Wordlist
  module Modifiers
    #
    # Lazily enumerates through every combination of a string substitution
    # on every word in the wordlist.
    #
    # @since 1.0.0
    #
    class Mutate < Sub

      #
      # Enumerates over every mutation of every word in the wordlist.
      #
      # @yield [word]
      #   The given block will be passed each mutation of each word.
      #
      # @yieldparam [String] word
      #   A mutated word.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      # @example
      #   wordlist = Wordlist::Words["foo", "bar", "baz"]
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
      def each
        return enum_for(__method__) unless block_given?

        @wordlist.each do |word|
          yield word

          matches = all_matches(word)

          each_combination(matches) do |selected_matches|
            new_word = word.dup
            offset   = 0

            selected_matches.each do |match|
              index, end_index = match.offset(0)
              length = end_index - index

              matched_string = match[0]
              replace_string = substitute(matched_string)

              new_word[index+offset,length] = replace_string

              offset += (replace_string.length - length)
            end

            yield new_word
          end
        end
      end

      private

      #
      # Finds all matches of the {#pattern} within a string.
      #
      # @param [String] string
      #   The given string.
      #
      # @return [Array<MatchData>]
      #   The array of all found non-overlapping matches.
      #
      def all_matches(string)
        offset  = 0
        matches = []

        while (match = string.match(@pattern,offset))
          index, end_index = match.offset(0)

          matches << match

          offset = end_index
        end

        return matches
      end

      #
      # Enumerates through every combination of every match.
      #
      # @param [Array<MatchData>] matches
      #   The array of matches.
      #
      # @yield [matches]
      #   The given block will be passed each combination of the matches.
      #
      # @yieldparam [Array<MatchData>] matches
      #   A combination of the matches.
      #
      def each_combination(matches,&block)
        (1..matches.length).each do |count|
          matches.combination(count,&block)
        end
      end

      #
      # Returns the replacement string for a matched substring.
      #
      # @param [String] matched
      #   The matched substring.
      #
      # @return [String]
      #   The replacement string.
      #
      def substitute(matched)
        case @replace
        when Hash   then @replace[matched].to_s
        when nil    then @block.call(matched)
        else             @replace
        end
      end

    end
  end
end
