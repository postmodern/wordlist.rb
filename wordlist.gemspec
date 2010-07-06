# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{wordlist}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Postmodern"]
  s.date = %q{2010-07-06}
  s.default_executable = %q{wordlist}
  s.description = %q{A Ruby library for generating and working with word-lists. Wordlist allows one to efficiently generate unique word-lists from arbitrary text or other sources, such as website content. Wordlist can also quickly enumerate through words within an existing word-list, applying multiple mutation rules to each word in the list.}
  s.email = %q{postmodern.mod3@gmail.com}
  s.executables = ["wordlist"]
  s.extra_rdoc_files = [
    "ChangeLog.md",
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".gitignore",
    ".specopts",
    ".yardopts",
    "ChangeLog.md",
    "Gemfile",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "bin/wordlist",
    "lib/wordlist.rb",
    "lib/wordlist/builder.rb",
    "lib/wordlist/builders.rb",
    "lib/wordlist/builders/website.rb",
    "lib/wordlist/flat_file.rb",
    "lib/wordlist/list.rb",
    "lib/wordlist/mutator.rb",
    "lib/wordlist/parsers.rb",
    "lib/wordlist/runners.rb",
    "lib/wordlist/runners/list.rb",
    "lib/wordlist/runners/runner.rb",
    "lib/wordlist/unique_filter.rb",
    "lib/wordlist/version.rb",
    "scripts/benchmark",
    "scripts/text/comedy_of_errors.txt",
    "spec/builder_examples.rb",
    "spec/builder_spec.rb",
    "spec/classes/parser_class.rb",
    "spec/classes/test_list.rb",
    "spec/flat_file_spec.rb",
    "spec/helpers/text.rb",
    "spec/helpers/wordlist.rb",
    "spec/list_spec.rb",
    "spec/mutator_spec.rb",
    "spec/parsers_spec.rb",
    "spec/spec_helper.rb",
    "spec/text/flat_file.txt",
    "spec/text/previous_wordlist.txt",
    "spec/text/sample.txt",
    "spec/unique_filter_spec.rb",
    "spec/wordlist_spec.rb",
    "wordlist.gemspec"
  ]
  s.has_rdoc = %q{yard}
  s.homepage = %q{http://github.com/sophsec/wordlist}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A Ruby library for generating and working with word-lists.}
  s.test_files = [
    "spec/builder_examples.rb",
    "spec/builder_spec.rb",
    "spec/classes/parser_class.rb",
    "spec/classes/test_list.rb",
    "spec/flat_file_spec.rb",
    "spec/helpers/text.rb",
    "spec/helpers/wordlist.rb",
    "spec/list_spec.rb",
    "spec/mutator_spec.rb",
    "spec/parsers_spec.rb",
    "spec/spec_helper.rb",
    "spec/unique_filter_spec.rb",
    "spec/wordlist_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<spidr>, [">= 0.1.9"])
      s.add_development_dependency(%q<bundler>, ["~> 0.9.25"])
      s.add_development_dependency(%q<rake>, ["~> 0.8.7"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.4.0"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3.0"])
    else
      s.add_dependency(%q<spidr>, [">= 0.1.9"])
      s.add_dependency(%q<bundler>, ["~> 0.9.25"])
      s.add_dependency(%q<rake>, ["~> 0.8.7"])
      s.add_dependency(%q<jeweler>, ["~> 1.4.0"])
      s.add_dependency(%q<rspec>, ["~> 1.3.0"])
    end
  else
    s.add_dependency(%q<spidr>, [">= 0.1.9"])
    s.add_dependency(%q<bundler>, ["~> 0.9.25"])
    s.add_dependency(%q<rake>, ["~> 0.8.7"])
    s.add_dependency(%q<jeweler>, ["~> 1.4.0"])
    s.add_dependency(%q<rspec>, ["~> 1.3.0"])
  end
end
