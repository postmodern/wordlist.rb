# Wordlist

[![CI](https://github.com/postmodern/wordlist.rb/actions/workflows/ruby.yml/badge.svg)](https://github.com/postmodern/wordlist.rb/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/postmodern/wordlist.rb.svg)](https://codeclimate.com/github/postmodern/wordlist.rb)
[![Gem Version](https://badge.fury.io/rb/wordlist.svg)](https://badge.fury.io/rb/wordlist)

* [Source](https://github.com/postmodern/wordlist.rb#readme)
* [Issues](https://github.com/postmodern/wordlist.rb/issues)
* [Documentation](https://rubydoc.info/gems/wordlist/frames)

## Description

Wordlist is a Ruby library and CLI for reading, combining, mutating, and
building wordlists, efficiently.

## Features

* Supports reading `.txt` wordlists, and `.gz`, `.bz2`, `.xz`, `.zip`, and `.7z`
  compressed wordlists.
* Supports building wordlists from arbitrary text. Also supports `.gz`, `.bz2,`
  and `.xz` compression.
* Provides an advanced lexer for parsing text into words.
  * Can parse/skip digits, special characters, whole numbers, acronyms.
  * Can normalize case, apostrophes, and acronyms.
* Supports wordlist operations for combining multiple wordlists together.
* Supports wordlist modify or mutating the words in the wordlist on the fly.
* Also provides a `wordlist` [command](#synopsis).
* [Fast-ish](#benchmarks)

## Examples

### Reading

Open a wordlist for reading:

```ruby
wordlist = Wordlist.open("passwords.txt")
```

Open a compressed wordlist for reading:

```ruby
wordlist = Wordlist.open("rockyou.txt.gz")
```

Enumerate through a wordlist:

```ruby
wordlist.each do |word|
  puts word
end
```

Create an in-memory list of literal words:

```ruby
words = Wordlist::Words["foo", "bar", "baz"]
```

### List Operations

Concat two wordlists together:

```ruby
(wordlist1 + wordlist2).each do |word|
  puts word
end
```

Union two wordlists together:

```ruby
(wordlist1 | wordlist2).each do |word|
  puts word
end
```

Subtract one wordlist from the other:

```ruby
(wordlist1 - wordlist2).each do |word|
  puts word
end
```

Combine every word from `wordlist1` with the words from `wordlist2`:

```ruby
(wordlist1 * wordlist2).each do |word|
  puts word
end
```

Combine the wordlist with itself multiple times:

```ruby
(wordslist ** 3).each do |word|
  puts word
end
```

Filter out duplicates from multiple wordlists:

```ruby
(wordlist1 + wordlist2 + wordlist3).uniq.each do |word|
  puts word
end
```

### String Manipulation

Convert every word in a wordlist to lowercase:

```ruby
wordlist.downcase.each do |word|
  puts word
end
```

Convert every word in a wordlist to UPPERCASE:

```ruby
wordlist.upcase.each do |word|
  puts word
end
```

Capitalize every word in a wordlist:

```ruby
wordlist.capitalize.each do |word|
  puts word
end
```

Run `String#tr` on every word in a wordlist:

```ruby
wordlist.tr('_','-').each do |word|
  puts word
end
```

Run `String#sub` on every word in a wordlist:

```ruby
wordlist.sub("fish","phish").each do |word|
  puts word
end
```

Run `String#gsub` on every word in a wordlist:

```ruby
wordlist.gsub(/\d+/,"").each do |word|
  puts word
end
```

Performs every possible mutation of each word in a wordlist:

```ruby
wordlist.mutate(/[oae]/, {'o' => '0', 'a' => '@', 'e' => '3'}).each do |word|
  puts word
end
# dog
# d0g
# firefox
# fir3fox
# firef0x
# fir3f0x
# ...
```

Enumerates over every possible case variation of every word in a wordlist:

```ruby
wordlist.mutate_case.each do |word|
  puts word
end
# cat
# Cat
# cAt
# caT
# CAt
# CaT
# cAT
# CAT
# ...
```

### Building a Wordlist

```ruby
Wordlist::Builder.open('path/to/file.txt.gz') do |builder|
  # ...
end
```

Add individual words:

```ruby
builder.add(word)
```

Adding an Array of words:

```ruby
builder.append(words)
```

Parsing text:

```ruby
builder.parse(text)
```

Parsing a file's content:

```ruby
builder.parse_file(path)
```

## Requirements

* [ruby] >= 2.0.0

[ruby]: https://www.ruby-lang.org/

## Install

```shell
$ gem install wordlist
```

### gemspec

```ruby
gem.add_dependency 'wordlist', '~> 1.0'
```

### Gemfile

```ruby
gem 'wordlist', '~> 1.0'
```

### Synopsis

Reading a wordlist:

```shell
$ wordlist rockyou.txt.gz
```

Reading multiple wordlists:

```shell
$ wordlist sport_teams.txt beers.txt
```

Combining every word from one wordlist with another:

```shell
$ wordlist sport_teams.txt -p beers.txt -p all_four_digits.txt
coors0000
coors0001
coors0002
coors0003
...
```

Combining every word from one wordlist with itself, N times:

```shell
$ wordlist words.txt -P 3
```

Mutating every word in a wordlist:

```shell
$ wordlist passwords.txt -m o:0 -m e:3 -m a:@
dog
d0g
firefox
fir3fox
firef0x
fir3f0x
...
```

Executing a command on each word in the wordlist:

```shell
$ wordlist directories.txt --exec "curl -X POST -F 'user=joe&password={}' -o /dev/null -w '%{http_code} {}' https://$TARGET/login"
```

Building a wordlist from a directory of `.txt` files:

```shell
$ wordlist --build wordlist.txt dir/*.txt
```

Building a wordlist from STDIN:

```shell
$ cat *.txt | wordlist --build wordlist.txt
```

## Benchmarks

```
                                               user     system      total        real
Wordlist::Builder#parse_text (size=5.4M)   1.943605   0.003809   1.947414 (  1.955960)
Wordlist::File#each (N=1000)               0.000544   0.000000   0.000544 (  0.000559)
Wordlist::File#concat (N=1000)             0.001143   0.000000   0.001143 (  0.001153)
Wordlist::File#subtract (N=1000)           0.001360   0.000000   0.001360 (  0.001375)
Wordlist::File#product (N=1000)            0.536518   0.005959   0.542477 (  0.545536)
Wordlist::File#power (N=1000)              0.000015   0.000001   0.000016 (  0.000014)
Wordlist::File#intersect (N=1000)          0.001389   0.000000   0.001389 (  0.001407)
Wordlist::File#union (N=1000)              0.001310   0.000000   0.001310 (  0.001317)
Wordlist::File#uniq (N=1000)               0.000941   0.000000   0.000941 (  0.000948)
Wordlist::File#tr (N=1000)                 0.000725   0.000000   0.000725 (  0.000736)
Wordlist::File#sub (N=1000)                0.000863   0.000000   0.000863 (  0.000870)
Wordlist::File#gsub (N=1000)               0.001240   0.000000   0.001240 (  0.001249)
Wordlist::File#capittalize (N=1000)        0.000821   0.000000   0.000821 (  0.000828)
Wordlist::File#upcase (N=1000)             0.000760   0.000000   0.000760 (  0.000769)
Wordlist::File#downcase (N=1000)           0.000544   0.000001   0.000545 (  0.000545)
Wordlist::File#mutate (N=1000)             0.004656   0.000000   0.004656 (  0.004692)
Wordlist::File#mutate_case (N=1000)       24.178521   0.000000  24.178521 ( 24.294962)
```

## License

Copyright (c) 2009-2023 Hal Brodigan

See {file:LICENSE.txt} for details.
