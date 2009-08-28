module Wordlist
  class Mutator

    include Enumerable

    # The pattern to match
    attr_accessor :pattern

    # The data to substitute matched text with
    attr_accessor :substitute

    def initialize(pattern,substitute)
      @pattern = pattern
      @substitute = substitute
    end

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

    def inspect
      "#{@pattern.inspect} -> #{@substitute.inspect}"
    end

  end
end
