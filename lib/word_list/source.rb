require 'word_list/exceptions/not_implemented'
require 'word_list/mutations'

module WordList
  class Source

    include Mutations
    include Enumerable

    # Default expected rate of duplicate words
    DUPLICATE_RATE = 0.1

    # Default expected number of words to generate
    MAX_WORDS = 500

    # Maximum number of words to generate
    attr_accessor :max_words

    # Acceptible rate of duplicate words
    attr_accessor :duplicate_rate

    def initialize(max_words=MAX_WORDS,duplicate_rate=DUPLICATE_RATE)
      @max_words = max_words.to_i
      @seen_words = 0

      @duplicate_rate = duplicate_rate
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
          break if @seen_words >= @max_words
        end
      end

      return self
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

    protected

    def setup_bloomfilter!
      m = (@max_words * Math.log(@duplicate_rate) / Math.log(1.0 / 2 ** Math.log(2)).ceil
      k = (Math.log(2) * m / @max_words).round

      @bloomfilter = BloomFilter.new(m,k,1)
      @seen_words = 0
    end

    def seen?(word)
      @bloomfilter.include?(word)
    end

    def saw!(word)
      @bloomfilter.insert(word)
      @seen_words += 1
    end

  end
end
