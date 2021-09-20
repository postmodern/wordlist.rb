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
words = Wordlist::List["foo", "bar", "baz"]
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

### String Manipulation

Convert every word in a wordlist to lowercase:

```ruby
wordlist.downcase.each do |word|
  puts word
end
```

Capitalize every word in a wordlist:

```ruby
wordlist.capitalize.each do |word|
  puts word
end
```

Performs every possible mutation of each word in a wordlist:

```ruby
wordlist.mutate(/[oae]/, {'o' => '0', 'a' => '@', 'e' => '3'}).each do |word|
  puts word
end
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

## License

Copyright (c) 2009-2021 Hal Brodigan

See {file:LICENSE.txt} for details.
