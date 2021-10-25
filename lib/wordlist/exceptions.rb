module Wordlist
  class WordlistNotFound < Errno::ENOENT
  end

  class UnknownFormat < ArgumentError
  end

  class CommandNotFound < Errno::ENOENT
  end

  class UnsupportedLanguage < ArgumentError
  end
end
