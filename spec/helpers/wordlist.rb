require 'tempfile'
require 'fileutils'

module Helpers
  def wordlist_tempfile(existing_file=nil)
    path = Tempfile.new('wordlist').path

    FileUtils.cp(existing_file,path) if existing_file
    return path
  end

  def should_contain_words(path,expected)
    words = []

    File.open(path) do |file|
      file.each_line do |line|
        words << line.chomp
      end
    end

    words.sort.should == expected.sort
  end
end
