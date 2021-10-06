require 'shellwords'

module Wordlist
  module Compression
    module Writer
      # Mapping of compression formats to the commands to write to them.
      COMMANDS = {
        gzip:  'gzip',
        bzip2: 'bzip2',
        xz:    'xz'
      }

      #
      # Returns the command to write to the compressed wordlist.
      #
      # @param [String] path
      #   The path to the file.
      #
      # @param [:gzip, :bzip2, :xz] format
      #   The compression format of the file.
      #
      # @param [Boolean] append
      #   Indicates that new words should be appended to the file instead of
      #   overwriting the file.
      #
      # @return [String]
      #   The shellescaped command string.
      #
      # @raise [ArgumentError]
      #   The given format was not `:gzip`, `:bzip2`, or `:xz`.
      #
      def self.command(path, format: , append: false)
        command  = COMMANDS.fetch(format) do
          raise(ArgumentError,"unsupported format: #{format.inspect}")
        end

        redirect = if append then '>>'
                   else           '>'
                   end

        return "#{Shellwords.shellescape(command)} #{redirect} #{Shellwords.shellescape(path)}"
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
      def self.open(path,**kwargs)
        IO.popen(command(path,**kwargs),'w')
      end
    end
  end
end
