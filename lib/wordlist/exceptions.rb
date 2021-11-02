module Wordlist
  class WordlistError < RuntimeError
  end

  class WordlistNotFound < WordlistError
  end

  class UnknownFormat < WordlistError
  end

  class CommandNotFound < WordlistError
  end

  class UnsupportedLanguage < WordlistError
  end
end
