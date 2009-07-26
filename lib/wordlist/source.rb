require 'wordlist/unique_filter'
require 'wordlist/mutations'

module Wordlist
  class Source

    include Mutations
    include Enumerable

    def initialize(options={})
      @filter = nil
    end

    def each_word
    end

    def each_unique
      @filter = UniqueFilter.new()

      each_word do |word|
        if @filter.saw!(word)
          yield word
        end
      end

      @filter = nil
    end

    def each_mutated(&block)
      each_unique do |word|
        each_mutation(word) do |mutated_word|
          unless seen?(mutated_word)
            saw!(mutated_word)
            block.call(word)

            return self if @seen_words >= @max_words
          end
        end
      end
    end

    alias each each_mutated

  end
end
