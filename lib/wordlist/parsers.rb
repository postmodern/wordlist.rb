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
  module Parsers
    def self.included(base)
      base.module_eval do
        # Ignore case of parsed text
        attr_accessor :ignore_case

        # Ignore the punctuation of parsed text
        attr_accessor :ignore_punctuation

        # Ignore URLs
        attr_accessor :ignore_urls

        # Ignore Phone numbers
        attr_accessor :ignore_phone_numbers

        # Ignore References
        attr_accessor :ignore_references
      end
    end

    def initialize
      @ignore_case = false
      @ignore_punctuation = true
      @ignore_urls = true
      @ignore_phone_numbers = false
      @ignore_references = false
    end

    #
    # Parses the specified _text_ and returns an Array of tokens.
    #
    def parse(text)
      text = text.to_s

      if @ignore_punctuation
        # eat tailing punctuation
        text.gsub!(/[\.\?!]*$/,'')
      end

      if @ignore_case
        # downcase the sentence
        text.downcase!
      end

      if @ignore_urls
        text.gsub!(/\s*\w+:\/\/[\w\/\+_\-,:%\d\.\-\?&=]*\s*/,' ')
      end

      if @ignore_phone_numbers
        # remove phone numbers
        text.gsub!(/\s*(\d-)?(\d{3}-)?\d{3}-\d{4}\s*/,' ')
      end

      if @ignore_references
        # remove RFC style references
        text.gsub!(/\s*[\(\{\[]\d+[\)\}\]]\s*/,' ')
      end

      if @ignore_punctuation
        # split and ignore punctuation characters
        return text.scan(/\w+[\-_\.:']\w+|\w+/)
      else
        # split and accept punctuation characters
        return text.scan(/[\w\-_,:;\.\?\!'"\\\/]+/)
      end
    end
  end
end
