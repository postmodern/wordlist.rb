require 'wordlist/modifiers/modifier'

module Wordlist
  module Modifiers
    class EachCase < Modifier

      def each
        return enum_for(__method__) unless block_given?

        @wordlist.each do |word|
          num_bits     = word.length
          permutations = (2 ** num_bits) - 1

          (0..permutations).each do |permutation|
            new_word = word.downcase

            (0...num_bits).each do |index|
              if (permutation & (1 << index)) > 0
                new_word[index] = new_word[index].upcase
              end
            end

            yield new_word
          end
        end
      end

    end
  end
end
