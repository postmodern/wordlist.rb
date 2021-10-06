require 'shellwords'

module Wordlist
  module Compression
    module Reader
      # Mapping of compression formats to the commands to read them.
      COMMANDS = {
        gzip:  'zcat',
        bzip2: 'bzcat',
        xz:    'xzcat'
      }

      #
      # Returns the command to read the compressed wordlist.
      #
      # @param [String] path
      #   The path to the file.
      #
      # @param [:gzip, :bzip2, :xz] format
      #   The compression format of the file.
      #
      # @return [String]
      #   The shellescaped command string.
      #
      # @raise [ArgumentError]
      #   The given format was not `:gzip`, `:bzip2`, or `:xz`.
      #
      def self.command(path, format: )
        command = COMMANDS.fetch(format) do
          raise(ArgumentError,"unsupported format: #{format.inspect}")
        end

        Shellwords.shelljoin([command, path])
      end

      #
      # Opens the compressed wordlist for reading.
      #
      # @param [String] path
      #   The path to the file.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments for {command}.
      #
      # @return [IO]
      #   The uncompressed IO stream.
      #
      # @raise [ArgumentError]
      #   The given format was not `:gzip`, `:bzip2`, or `:xz`.
      #
      def self.open(path,**kwargs,&block)
        IO.popen(command(path,**kwargs),&block)
      end
    end
  end
end
