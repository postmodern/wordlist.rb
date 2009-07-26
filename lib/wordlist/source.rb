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

require 'wordlist/unique_filter'
require 'wordlist/mutations'

module Wordlist
  class Source

    include Mutations
    include Enumerable

    def initialize(options={})
      @filter = nil
    end

    def each_word
    end

    def each_unique
      @filter = UniqueFilter.new()

      each_word do |word|
        if @filter.saw!(word)
          yield word
        end
      end

      @filter = nil
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

  end
end
