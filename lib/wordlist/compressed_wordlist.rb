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

      IO.popen(command) do |io|
        io.each_line(&block)
      end
    end

    #
    # The command used to read the compressed wordlist.
    #
    # @return [String]
    #   The command to run.
    #
    # @raise [NotImplementedError]
    #   The class did not define a {command}.
    #
    # @api private
    #
    def command
      if (command = self.class.command)
        Shellwords.shelljoin([command, path])
      else
        raise(NotImplementedError,"#{self.class} did not define a command")
      end
    end

    #
    # Defines the command used to read the compressed wordlist.
    #
    # @param [String, nil] new_command
    #
    # @return [String]
    #
    # @api semipublic
    #
    def self.command(new_command=nil)
      if new_command then @command = new_command
      else                @command
      end
    end

  end
end
