module Wordlist
  class Mutator

    include Enumerable

    # The pattern to match
    attr_accessor :pattern

    # The data to substitute matched text with
    attr_accessor :substitute

    #
    # Creates a new Mutator object.
    #
    # @param [String, Regexp] pattern
    #   The pattern which recognizes text to mutate.
    #
    # @param [String, Integer] substitute
    #   The optional text to replace recognized text.
    #
    # @yield [match]
    #   If a block is given, it will be used to mutate recognized text.
    #
    # @yieldparam [String] match
    #   The match text to mutate.
    #
    def initialize(pattern,substitute=nil,&block)
      @pattern = pattern
      @substitute = (substitute || block)
    end

    #
    # Mutates the given text.
    #
    # @param [String] matched
    #   The recognized text to be mutated.
    #
    # @return [String]
    #   The mutated text.
    #
    def replace(matched)
      result = if @substitute.kind_of?(Proc)
                 @substitute.call(matched)
               else
                 @substitute
               end

      result = if result.kind_of?(Integer)
                 result.chr
               else
                 result.to_s
               end

      return result
    end

    #
    # Enumerates over every possible mutation of the given word.
    #
    # @param [String] word
    #   The word to mutate.
    #
    # @yield [mutation]
    #   The given block will be passed every possible mutation of the
    #   given word.
    #
    # @yieldparam [String] mutation
    #   One possible mutation of the given word.
    #
    # @return [String]
    #   The original word.
    #
    def each(word)
      choices = 0

      # first iteration
      yield(word.gsub(@pattern) { |matched|
        # determine how many possible choices there are
        choices = ((choices << 1) | 0x1)

        replace(matched)
      })

      (choices - 1).downto(0) do |iteration|
        bits = iteration

        yield(word.gsub(@pattern) { |matched|
          result = if ((bits & 0x1) == 0x1)
                     replace(matched)
                   else
                     matched
                   end

          bits >>= 1
          result
        })
      end

      return word
    end

    #
    # Inspects the mutator.
    #
    # @return [String]
    #   The inspected mutator.
    #
    def inspect
      "#{@pattern.inspect} -> #{@substitute.inspect}"
    end

  end
end
