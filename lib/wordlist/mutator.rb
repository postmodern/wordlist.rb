#
#--
# Wordlist - A Ruby library for generating and working with word lists.
#
# Copyright (c) 2009 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#++
#

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

    def each(word,&block)
      n = 0

      # first iteration
      yield(word.gsub(@pattern) { |matched|
        n += 1 # find maximum replacements done
        replace(matched)
      })

      (n - 1).downto(0) do |iteration|
        yield(word.gsub(@pattern) { |matched|
          result = if (iteration & 0x1)
                     replace(matched)
                   else
                     matched
                   end

          iteration >>= 1
          result
        })
      end

      return word
    end

    def inspect
      "#{@pattern.inspect} -> #{@replacement.inspect}"
    end

  end
end
