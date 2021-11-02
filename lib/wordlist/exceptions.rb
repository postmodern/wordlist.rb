module Wordlist
  #
  # @since 1.0.0
  #
  class WordlistError < RuntimeError
  end

  #
  # @since 1.0.0
  #
  class WordlistNotFound < WordlistError
  end

  #
  # @since 1.0.0
  #
  class UnknownFormat < WordlistError
  end

  #
  # @since 1.0.0
  #
  class CommandNotFound < WordlistError
  end

  #
  # @since 1.0.0
  #
  class UnsupportedLanguage < WordlistError
  end
end
