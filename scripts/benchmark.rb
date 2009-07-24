#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'..','lib')))

require 'wordlist/builder'
require 'benchmark'

path = File.expand_path(File.join(File.dirname(__FILE__),'shakespeare_wordlist.txt'))

Benchmark.bm do |bm|
  bm.report('build:') do
    Wordlist::Builder.build(path) do |wordlist|
      wordlist.parse_file('/home/hal/shaks12.txt')
    end
  end
end
