# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'

Hoe.plugin :yard

Hoe.spec('wordlist') do
  self.developer('Postmodern','postmodern.mod3@gmail.com')

  self.rspec_options += ['--colour', '--format', 'specdoc']

  self.yard_options += ['--protected']
  self.remote_yard_dir = '/'

  self.extra_deps = [
    ['spidr', '>=0.1.9']
  ]

  self.extra_dev_deps = [
    ['rspec', '>=1.3.0']
  ]
end

# vim: syntax=Ruby
