= Wordlist

* http://wordlist.rubyforge.org/
* http://github.com/sophsec/wordlist/
* Postmodern (postmodern.mod3 at gmail.com)

== DESCRIPTION:

A Ruby library for generating and working with word-lists. Wordlist allows
one to efficiently generate unique word-lists from arbitrary text or
other sources, such as website content. Wordlist can also quickly enumerate
through words within an existing word-list, applying multiple mutation
rules to each word in the list.

== FEATURES:

* Uses a bucket system of CRC32 hashes for efficient filtering of duplicate
  words.
* Supports adding mutation rules to a word-list, which are applied to
  words as the list is enumerated.
* Supports building word-lists from arbitrary text.
* Supports custom word-list builders:
  * Wordlist::Builders::Website: Build word-lists from website content.
* Supports custom word-list formats:
  * Wordlist::FlatFile: Enumerates through the words in a flat-file
    word-list.

== EXAMPLES:

* Build a word-list from arbitrary text:

    Wordlist::Builder.build('list.txt') do |builder|
      builder.parse(some_text)
    end

* Build a word-list from another file:

    Wordlist::Builder.build('list.txt') do |builder|
      builder.parse_file('some/file.txt')
    end

* Build a word-list from content off a website:

    require 'wordlist/builders/website'

    Wordlist::Builders::Website.build('list.txt','www.example.com')

* Enumerate through each word in a flat-file word-list:

    list = Wordlist::FlatFile.new('list.txt')
    list.each_word do |word|
      puts word
    end

* Enumerate through each unique word in a flat-file word-list:

    list.each_unique do |word|
      puts word
    end

* Define mutation rules, and enumerate through each unique mutation of each
  unique word in the word-list:

    list.mutate 'o', '0'
    list.mutate '@', 0x41
    list.mutate(/[hax]/i) { |match| match.swapcase }

    list.each_mutation do |word|
      puts word
    end

== REQUIREMENTS:

* {spidr}[http://spidr.rubyforge.org] >= 0.1.9

== INSTALL:

  $ sudo gem install wordlist

== LICENSE:

Wordlist - A Ruby library for generating and working with word-lists.

Copyright (c) 2009 Hal Brodigan

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
