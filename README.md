# Wordlist

* [Source](https://github.com/postmodern/wordlist#readme)
* [Issues](https://github.com/postmodern/wordlist/issues)
* [Documentation](https://rubydoc.info/gems/wordlist/frames)

## Description

Wordlist is a Ruby library for reading, manipulating, and creating wordlists,
efficiently.

## Features

* Supports reading `.txt` wordlists, and `.txt.gz`, `.txt.bz2`, and `.txt.xz`
  compressed wordlists.
* Supports building wordlists from arbitrary text. Also supports `.gz`, `.bz2,`
  and `.xz` compression.
* Provides an advanced lexer for parsing text into words.
  * Can parse/skip digits, special characters, whole numbers, acronyms.
  * Can normalize case, apostrophes, and acronyms.
* Supports wordlist operations for combining multiple wordlists together.
* Supports wordlist manipulating to modify the words in the wordlist on the fly.
* Fast-ish

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
```

Enumerates over every possible case variation of every word in a wordlist:

```ruby
wordlist.mutate_case.each do |word|
  puts word
end
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
```

Combining every word from one wordlist with itself, N times:

```shell
$ wordlist shakespeare.txt -P 3
```

Mutating every word in a wordlist:

```shell
$ wordlist passwords.txt -m o:0 -m e:3 -m a:@
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

## License

Copyright (c) 2009-2021 Hal Brodigan

See {file:LICENSE.txt} for details.
