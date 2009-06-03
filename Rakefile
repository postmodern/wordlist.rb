# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './tasks/spec.rb'
require './lib/word_list/version.rb'

Hoe.spec('word') do |p|
  p.rubyforge_name = 'wordlist'
  p.developer('Postmodern','postmodern.mod3@gmail.com')
  p.remote_rdoc_dir = '/'
  p.extra_deps = [
    'bloomfilter',
    ['spidr', '>=0.1.5']
  ]
end

# vim: syntax=Ruby
