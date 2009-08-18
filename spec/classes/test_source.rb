require 'wordlist/source'

class TestSource < Wordlist::Source

  def each_word
    yield 'omg.hackers'
  end

end
