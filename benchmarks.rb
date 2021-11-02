#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path(File.join(__dir__,'lib')))
require 'wordlist'
require 'fileutils'
require 'benchmark'

DIR       = File.join(__dir__,'benchmarks')
TEXT_FILE = File.join(DIR,'shaks12.txt')
WORDLIST1 = File.join(DIR,'wordlist1.txt')
WORDLIST2 = File.join(DIR,'wordlist2.txt')
N = 1_000

FileUtils.mkdir_p(DIR)

unless File.file?(TEXT_FILE)
  require' net/https'

  uri = URI('https://www.gutenberg.org/files/100/old/shaks12.txt')

  Net::HTTP.start(uri.host, uri.port) do |http|
    request = Net::HTTP::Get.new(uri)

    http.request(request) do |response|
      File.open(TEXT_FILE,'w') do |file|
        response.read_body do |chunk|
          file.write(chunk)
        end
      end
    end
  end
end

unless File.file?(WORDLIST1)
  system("head -n #{N} /usr/share/dict/words > #{WORDLIST1}")
end

unless File.file?(WORDLIST2)
  system("tail -n #{N} /usr/share/dict/words > #{WORDLIST2}")
end

Benchmark.bm(40) do |b|
  b.report("Wordlist::Builder#parse_text (size=5.4M)") do
    Wordlist::Builder.open(File.join(DIR,'shakespeare.txt')) do |builder|
      builder.parse_file(TEXT_FILE)
    end
  end

  b.report("Wordlist::File#each (N=#{N})") do
    Wordlist::File.open(WORDLIST1).each { |word| }
  end

  wordlist1 = Wordlist::File.open(WORDLIST1)
  wordlist2 = Wordlist::File.open(WORDLIST2)

  b.report("Wordlist::File#concat (N=#{N})") do
    wordlist1.concat(wordlist2).each { |word| }
  end

  b.report("Wordlist::File#subtract (N=#{N})") do
    wordlist1.subtract(wordlist2).each { |word| }
  end

  b.report("Wordlist::File#product (N=#{N})") do
    wordlist1.product(wordlist2).each { |word| }
  end

  b.report("Wordlist::File#power (N=#{N})") do
    wordlist1.power(2)
  end

  b.report("Wordlist::File#intersect (N=#{N})") do
    wordlist1.intersect(wordlist2).each { |word| }
  end

  b.report("Wordlist::File#union (N=#{N})") do
    wordlist1.union(wordlist2).each { |word| }
  end

  b.report("Wordlist::File#uniq (N=#{N})") do
    wordlist1.uniq.each { |word| }
  end

  b.report("Wordlist::File#tr (N=#{N})") do
    wordlist1.tr("e","3").each { |word| }
  end

  b.report("Wordlist::File#sub (N=#{N})") do
    wordlist1.sub("e","3").each { |word| }
  end

  b.report("Wordlist::File#gsub (N=#{N})") do
    wordlist1.gsub("e","3").each { |word| }
  end

  b.report("Wordlist::File#capittalize (N=#{N})") do
    wordlist1.capitalize.each { |word| }
  end

  b.report("Wordlist::File#upcase (N=#{N})") do
    wordlist1.upcase.each { |word| }
  end

  b.report("Wordlist::File#downcase (N=#{N})") do
    wordlist1.downcase.each { |word| }
  end

  b.report("Wordlist::File#mutate (N=#{N})") do
    wordlist1.mutate("e","3").each { |word| }
  end

  b.report("Wordlist::File#mutate_case (N=#{N})") do
    wordlist1.mutate_case.each { |word| }
  end
end
