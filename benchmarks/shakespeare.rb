$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'..','lib')))

require 'wordlist/builder'
require 'benchmark'

Benchmark.bm do |bm|
  bm.report('build:') do
    Wordlist::Builder.build('shakespeare_wordlist.txt') do |wordlist|
      wordlist.parse_file('/home/hal/shaks12.txt')
    end
  end
end
