require 'wordlist/exceptions/not_implemented'
require 'wordlist/mutations'

require 'bloomfilter'

module Wordlist
  class Source

    include Mutations
    include Enumerable

    # Default expected rate of duplicate words
    DUPLICATE_RATE = 0.1

    # Default expected number of words to generate
    MAX_WORDS = 1000

    # Maximum number of words to generate
    attr_accessor :max_words

    # Acceptible rate of duplicate words
    attr_accessor :duplicate_rate

    def initialize(options={})
      @max_words = (options[:max_words] || MAX_WORDS).to_i
      @seen_words = 0

      @duplicate_rate = (options[:duplicate_rate] || DUPLICATE_RATE).to_f
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

      destroy_bloomfilter!
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
      @bloomfilter = BloomFilter.new
      @seen_words = 0
    end

    def seen?(word)
      @bloomfilter.include?(word)
    end

    def saw!(word)
      @bloomfilter.insert(word)
      @seen_words += 1
    end

    def destroy_bloomfilter!
      @seen_words = 0
      @bloomfilter = nil
    end

  end
end
