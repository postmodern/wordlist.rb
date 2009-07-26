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

require 'set'

module Wordlist
  class UniqueFilter

    # CRC32 Hashes of words seen so far
    attr_reader :seen

    #
    # Creates a new UniqueFilter object.
    #
    def initialize
      @seen = {}
    end

    #
    # Returns +true+ if the _word_ has been previously seen, returns
    # +false+ otherwise.
    #
    def seen?(word)
      length = word.length

      (@seen.has_key?(length) && @seen[length].include?(crc32(word)))
    end

    #
    # Marks the specified _word_ as seen and returns +true+. If the _word_
    # has been previously been seen, +false+ will be returned.
    #
    def saw!(word)
      length = word.length
      crc = crc32(word)

      if @seen.has_key?(length)
        return false if @seen[length].include?(crc)
        @seen[length] << crc
      else
        @seen[length] = SortedSet[crc]
      end

      return true
    end

    #
    # Passes the specified _word_ through the unique filter, if the
    # _word_ has not yet been seen, it will be passed to the given _block_.
    #
    def pass(word)
      if saw!(word)
        yield word
      end

      return nil
    end

    protected

    #
    # Returns the CRC32 checksum of the specified _word_.
    #
    def crc32(word)
      r = 0xffffffff

      word.each_byte do |b|
        r ^= b
        8.times { r = ((r >> 1) ^ (0xEDB88320 * (r & 1))) }
      end

      r ^ 0xffffffff
    end

  end
end
