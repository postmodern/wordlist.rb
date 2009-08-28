= Wordlist

* http://wordlist.rubyforge.org/
* http://github.com/sophsec/wordlist/
* Postmodern (postmodern.mod3 at gmail.com)

== DESCRIPTION:

A Ruby library for generating and working with wordlists.

== FEATURES:

* Uses a bucket system of CRC32 hashes for efficient filtering of duplicate
  words.
* Provides Wordlist::Mutations for defining mutations to apply to words.
* Supports building wordlists from arbitrary text.
* Supports custom builders:
  * Wordlist::Builders::Website: Build word lists from web-site content.

== EXAMPLES:

== REQUIREMENTS:

== INSTALL:

  $ sudo gem install wordlist

== LICENSE:

Wordlist - A Ruby library for generating and working with wordlists.

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
