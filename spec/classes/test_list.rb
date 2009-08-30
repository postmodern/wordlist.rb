require 'wordlist/list'

class TestList < Wordlist::List

  def each_word
    yield 'omg.hackers'
  end

end
