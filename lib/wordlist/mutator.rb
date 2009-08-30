module Wordlist
  class Mutator

    include Enumerable

    # The pattern to match
    attr_accessor :pattern

    # The data to substitute matched text with
    attr_accessor :substitute

    #
    # Creates a new Mutator with the specified _pattern_ and _substitute_
    # data. If a _block_ is given, and the _substitute_ data is omitted, then
    # the _block_ will be used to replace data matched by the _pattern_.
    #
    def initialize(pattern,substitute=nil,&block)
      @pattern = pattern
      @substitute = (substitute || block)
    end

    #
    # Replaces the specified _matched_ data using the +substitute+, which
    # may be either a String, Integer or Proc.
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
    # Performs every possible replacement of data, which matches the
    # mutators +pattern+ using the replace method, on the specified _word_
    # passing each variation to the given _block_.
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
    def inspect
      "#{@pattern.inspect} -> #{@substitute.inspect}"
    end

  end
end
