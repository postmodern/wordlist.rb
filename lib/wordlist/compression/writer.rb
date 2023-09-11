require 'wordlist/exceptions'

require 'shellwords'

module Wordlist
  module Compression
    #
    # Handles writing compressed files.
    #
    # @since 1.0.0
    #
    module Writer
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
      # @raise [UnknownFormat]
      #   The given format was not `:gzip`, `:bzip2`, or `:xz`.
      #
      def self.command(path, format: , append: false)
        case format
        when :gzip, :bzip2, :xz
          command  = format.to_s
          redirect = if append then '>>'
                     else           '>'
                     end

          "#{command} #{redirect} #{Shellwords.shellescape(path)}"
        else
          raise(UnknownFormat,"unsupported output format: #{format.inspect}")
        end
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
      # @raise [CommandNotFound]
      #   The `gzip`, `bzip2,` or `xz` command was not found on the system.
      #
      def self.open(path,**kwargs)
        command = self.command(path,**kwargs)

        begin
          IO.popen(command,'w')
        rescue Errno::ENOENT
          raise(CommandNotFound,"#{command.inspect} command not found")
        end
      end
    end
  end
end
