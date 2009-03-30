require 'word_list/exceptions/not_implemented'
require 'word_list/mutations'

module WordList
  class Source

    include Mutations
    include Enumerable

    def initialize(m,k,seed)
      @m = m
      @k = k
      @seed = seed
    end

    def each_word(&block)
      raise(NotImplemented,"the each_word method must be implemented",caller)
    end

    def each_unique(&block)
      setup_bloomfilter!

      each_word do |word|
        unless seen?(word)
          saw!(word)

          block.call(word)
        end
      end
    end

    def each_mutated(&block)
      each_unique do |word|
        each_mutation(word) do |mutated_word|
          unless seen?(mutated_word)
            saw!(mutated_word)
            block.call(word)
          end
        end
      end
    end

    alias each each_mutation

    protected

    def setup_bloomfilter!
      @bloomfilter = BloomFilter.new(@m,@k,@seed)
    end

    def seen?(word)
      @bloomfilter.include?(word)
    end

    def saw!(word)
      @bloomfilter.insert(word)
    end

  end
end
