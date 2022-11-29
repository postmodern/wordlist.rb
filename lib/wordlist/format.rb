# frozen_string_literal: true
require 'wordlist/exceptions'

module Wordlist
  #
  # Handles wordlist format detection.
  #
  # @since 1.0.0
  #
  module Format
    # Mapping of file extensions to formats
    FILE_FORMATS = {
      '.txt' => :txt,
      '.gz'  => :gzip,
      '.bz2' => :bzip2,
      '.xz'  => :xz
    }

    # Valid formats.
    FORMATS = FILE_FORMATS.values

    #
    # Infers the format from the given file name.
    #
    # @param [String] path
    #   The path to the file.
    #
    # @return [:txt, :gzip, :bzip2, :xz]
    #
    # @raise [UnknownFormat]
    #   The format could not be inferred from the file path.
    #
    def self.infer(path)
      FILE_FORMATS.fetch(::File.extname(path)) do
        raise(UnknownFormat,"could not infer the format of file: #{path.inspect}")
      end
    end
  end
end
