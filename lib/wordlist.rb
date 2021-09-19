require 'wordlist/txt'
require 'wordlist/gzip'
require 'wordlist/bzip2'
require 'wordlist/xz'
require 'wordlist/list'
require 'wordlist/version'

module Wordlist
  # 
  # Creates an in-memory wordlist from the given words.
  #
  # @param [Array<String>] words
  #   The literal words for the list.
  #
  # @return [List]
  #   The in-memory wordlist.
  #
  # @api public
  #
  def self.[](*words)
    List[*words]
  end

  class UnsupportedFileExt < ArgumentError
  end

  # @api private
  FORMATS = {
    :txt   => TXT,
    :gzip  => GZip,
    :bzip2 => BZip2,
    :xz    => XZ
  }

  # @api private
  FILE_EXTS = {
    '.txt' => TXT,
    '.gz'  => GZip,
    '.bz'  => BZip2,
    '.bz2' => BZip2,
    '.xz'  => XZ
  }

  #
  # Opens a wordlist file.
  #
  # @param [String] path
  #   The path to the file.
  #
  # @param [:txt, :bzip, :bzip2, :xz] format
  #   Specifies the format of the wordlist. If no format is given, the format
  #   will be inferred from the path's file extension.
  #
  # @yield [wordlist]
  #   If a block is given, it will be passed the newly opened wordlist.
  #
  # @yieldparam [Wordlist::TXT, Wordlist::GZip, Wordlist::BZip2, Wordlist::XZ] wordlist
  #   The newly opened wordlist.
  #
  # @return [Wordlist::TXT, Wordlist::GZip, Wordlist::BZip2, Wordlist::XZ]
  #   The opened wordlist.
  #
  # @raise [ArgumentError]
  #   `format: was not `:txt`, `:gzip`, :bzip2`, or `:xz`.
  #
  # @raise [UnsupportedFileExt]
  #   No `format:` was given, the wordlist format could not be inferred from the
  #   path's file extension.
  #
  # @api public
  #
  def self.open(path, format: nil)
    file_ext = File.extname(path)

    wordlist_class = if format
                       FORMATS.fetch(format) do
                         raise(ArgumentError,"format: keyword value (#{format.inspect}) must be either :txt, :gzip, :bzip2, or :xz")
                       end
                     else
                       FILE_EXTS.fetch(file_ext) do
                         raise(UnsupportedFileExt,"unsupported file extension #{file_ext.inspect}. Supported file extensions are #{FILE_EXTS.keys.join(', ')}")
                       end
                     end

    wordlist = wordlist_class.new(path)
    yield wordlist if block_given?
    wordlist
  end
end
