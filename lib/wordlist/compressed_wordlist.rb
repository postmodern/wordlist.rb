require 'wordlist/txt'

require 'shellwords'

module Wordlist
  class CompressedWordlist < TXT

    #
    # Enumerates over each line in the compressed wordlist.
    #
    # @yield [line]
    #   The given block will be passed each line from the compressed wordlist.
    #
    # @yieldparam [String] line
    #   A newline terminated line from the compressed wordlist.
    #
    # @api semipublic
    #
    def each_line(&block)
      return enum_for(__method__) unless block

      IO.popen(Shellwords.shelljoin([command, path])) do |io|
        io.each_line(&block)
      end
    end

    #
    # The command used to read the compressed wordlist.
    #
    # @return [String]
    #
    # @abstract
    #
    # @api private
    #
    def command
      raise(NotImplementedError,"#{self.class} did not define a command")
    end

    #
    # Defines the command used to read the compressed wordlist.
    #
    # @param [String] new_command
    #
    # @api semipublic
    #
    private def self.command(new_command)
      define_method(:command) { new_command }
    end

  end
end
