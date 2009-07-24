require 'wordlist/builder'

Wordlist::Builder.build('shakespeare_wordlist.txt') do |wordlist|
  wordlist.parse_file(File.join('text','comedy_of_errors.txt'))
end
