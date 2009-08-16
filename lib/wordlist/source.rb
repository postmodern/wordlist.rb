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
require 'wordlist/mutator'

module Wordlist
  class Source

    include Enumerable

    # Maximum length of words
    attr_accessor :max_length

    # Minimum length of words
    attr_accessor :min_length

    def initialize(options={})
      @mutators = []

      @max_length = nil
      @min_length = 0

      @filter = nil
    end

    def mutate(pattern,substitute)
      @mutators << Mutator.new(pattern,substitute)
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

    def each_mutation(&block)
      next_mutator = lambda { |word|
        # skip words shorter than the minimum length
        next if mutated_word.length < @min_length

        # truncate words longer than the maximum length
        mutated_word = mutated_word[0,@max_length] if @max_length

        if @filter.saw!(mutated_word)
          yield mutated_word
        end
      }

      @mutators.reverse_each do |prev_mutator|
        next_mutator = lambda { |word|
          prev_mutator.each(&next_mutator)
        }
      end

      each_unique(&next_mutator)
    end

    alias each each_mutation

  end
end
