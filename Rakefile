require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:development, :doc)
rescue Bundler::BundlerError => e
  STDERR.puts e.message
  STDERR.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'jeweler'
require './lib/wordlist/version.rb'

Jeweler::Tasks.new do |gem|
  gem.name = 'wordlist'
  gem.version = Wordlist::VERSION
  gem.summary = %Q{A Ruby library for generating and working with word-lists.}
  gem.description = %Q{A Ruby library for generating and working with word-lists. Wordlist allows one to efficiently generate unique word-lists from arbitrary text or other sources, such as website content. Wordlist can also quickly enumerate through words within an existing word-list, applying multiple mutation rules to each word in the list.}
  gem.email = 'postmodern.mod3@gmail.com'
  gem.homepage = 'http://github.com/sophsec/wordlist'
  gem.authors = ['Postmodern']
  gem.has_rdoc = 'yard'
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs += ['lib', 'spec']
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.spec_opts = ['--options', '.specopts']
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
