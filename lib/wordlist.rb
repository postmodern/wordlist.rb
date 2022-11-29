# frozen_string_literal: true
require 'wordlist/words'
require 'wordlist/file'
require 'wordlist/builder'
require 'wordlist/version'

module Wordlist
  # 
  # Creates an in-memory wordlist from the given words.
  #
  # @param [Array<String>] words
  #   The literal words for the list.
  #
  # @return [File]
  #   The in-memory wordlist.
  #
  # @api public
  #
  # @since 1.0.0
  #
  def self.[](*words)
    Words[*words]
  end

  #
  # Opens a wordlist file.
  #
  # @param [String] path
  #   The path to the file.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {Wordlist::File#initialize}.
  #
  # @option kwargs [:txt, :bzip, :bzip2, :xz] :format
  #   Specifies the format of the wordlist. If no format is given, the format
  #   will be inferred from the path's file extension.
  #
  # @yield [wordlist]
  #   If a block is given, it will be passed the newly opened wordlist.
  #
  # @yieldparam [Wordlist::File] wordlist
  #   The newly opened wordlist.
  #
  # @return [Wordlist::File]
  #   The opened wordlist.
  #
  # @raise [ArgumentError]
  #   No `format:` was given, the wordlist format could not be inferred from the
  #   path's file extension.
  #
  # @api public
  #
  # @since 1.0.0
  #
  def self.open(path,**kwargs,&block)
    File.open(path,**kwargs,&block)
  end

  #
  # Creates a new wordlist builder.
  #
  # @param [String] path
  #   The path to the file.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {Builder#initialize}.
  #
  # @option kwargs [:txt, :bzip, :bzip2, :xz, nil] :format
  #   Specifies the format of the wordlist. If no format is given, the format
  #   will be inferred from the path's file extension.
  #
  # @option kwargs [Boolean] :append
  #   Specifies whether new words will be appended onto the end of the wordlist
  #   file or if it will be overwritten.
  #
  # @yield [builder]
  #   If a block is given, the newly created builder object will be yielded.
  #   After the block has returned the builder will automatically be closed.
  #
  # @yieldparam [Builder] builder
  #   The newly created builder object.
  #
  # @return [Builder]
  #
  # @raise [ArgumentError]
  #   No `format:` was given, the wordlist format could not be inferred from the
  #   path's file extension.
  #
  # @api public
  #
  # @since 1.0.0
  #
  def self.build(path,**kwargs)
    builder = Builder.new(path,**kwargs)

    if block_given?
      begin
        yield builder
      ensure
        builder.close
      end
    end

    return builder
  end
end
