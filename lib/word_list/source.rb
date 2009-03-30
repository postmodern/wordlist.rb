require 'word_list/exceptions/not_implemented'
require 'word_list/mutations'

module WordList
  class Source

    include Mutations
    include Enumerable

    # Default expected bloomfilter false-positive rate
    FALSE_POSITIVE_RATE = 0.1

    # Maximum number of words to generate
    attr_accessor :max_words

    # Accepted false-positive rate of the bloomfilter
    attr_accessor :false_positive_rate

    def initialize(max_words,false_positive_rate=FALSE_POSITIVE_RATE)
      @max_words = max_words.to_i
      @seen_words = 0

      @false_positive_rate = false_positive_rate
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
    end

    def each_mutated(&block)
      each_unique do |word|
        each_mutation(word) do |mutated_word|
          unless seen?(mutated_word)
            saw!(mutated_word)
            block.call(word)

            break if @seen_words >= @max_words
          end
        end
      end
    end

    alias each each_mutation

    protected

    def setup_bloomfilter!
      m = (@max_words * Math.log(@false_positive_rate) / Math.log(1.0 / 2 ** Math.log(2)).ceil
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
