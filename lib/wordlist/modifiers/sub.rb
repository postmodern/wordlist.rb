require 'wordlist/modifiers/modifier'

module Wordlist
  module Modifiers
    #
    # Lazily calls `String#sub` on every word in the wordlist.
    #
    class Sub < Modifier

      # The pattern to substitute.
      #
      # @return [Regexp, String]
      attr_reader :pattern

      # The replacement String or map of Strings.
      #
      # @return [String, Hash{String => String, nil}]
      attr_reader :replace

      # The optional block to call when replacing matched substrings.
      #
      # @return [Proc, nil]
      attr_reader :block

      #
      # Initializes the `String#sub` modifier.
      #
      # @param [Regexp, String] pattern
      #   The pattern to replace.
      #
      # @param [String, Hash, nil] replace
      #   The characters or character range to use as the replacement.
      #
      # @yield [match]
      #   The given block will be call to replace the matched substring,
      #   if `replace` is nil.
      #
      # @yieldparam [String] match
      #   A matched substring.
      #
      # @raise [TypeError]
      #   The `replace` value was not a String, Hash, or `nil`.
      #
      def initialize(wordlist,pattern,replace=nil,&block)
        super(wordlist)

        @pattern = pattern
        @replace = case replace
                   when String, Hash, nil then replace
                   else
                     raise(TypeError,"no implicit conversion of #{replace.class} to String")
                   end
        @block   = block
      end

      #
      # @api public
      #
      def each
        return enum_for(__method__) unless block_given?

        if @replace
          @wordlist.each do |word|
            yield word.sub(@pattern,@replace)
          end
        else
          @wordlist.each do |word|
            yield word.sub(@pattern,&block)
          end
        end
      end

    end
  end
end
