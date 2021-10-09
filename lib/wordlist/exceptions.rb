module Wordlist
  class WordlistNotFound < Errno::ENOENT
  end

  class UnknownFormat < ArgumentError
  end
end
