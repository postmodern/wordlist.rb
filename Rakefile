# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'
require './lib/wordlist/version.rb'

Hoe.spec('wordlist') do
  self.rubyforge_name = 'wordlist'
  self.developer('Postmodern','postmodern.mod3@gmail.com')

  self.rspec_options += ['--colour', '--format', 'specdoc']

  self.remote_rdoc_dir = '/'
  self.extra_deps = [
    ['spidr', '>=0.1.9']
  ]

  self.extra_dev_deps = [
    ['rspec', '>=1.1.12']
  ]
end

# vim: syntax=Ruby
