require 'wordlist/modifiers/sub'

module Wordlist
  module Modifiers
    #
    # Lazily calls `String#gsub` on every word in the wordlist.
    #
    class Gsub < Sub

      #
      # @api public
      #
      def each
        return enum_for(__method__) unless block_given?

        if @replace
          @wordlist.each do |word|
            yield word.gsub(@pattern,@replace)
          end
        else
          @wordlist.each do |word|
            yield word.gsub(@pattern,&block)
          end
        end
      end

    end
  end
end
