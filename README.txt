= Wordlist

* http://wordlist.rubyforge.org/
* http://github.com/postmodern/wordlist/
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

Wordlist - A Ruby library for generating and working with word lists.

Copyright (c) 2009 Hal Brodigan (postmodern.mod3 at gmail.com)

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
