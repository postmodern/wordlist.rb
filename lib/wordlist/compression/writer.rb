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
      # @param [:gzip, :bzip2, :xz, :zip] format
      #   The compression format of the file.
      #
      # @param [Boolean] append
      #   Indicates that new words should be appended to the file instead of
      #   overwriting the file.
      #
      # @return [String]
      #   The shellescaped command string.
      #
      # @raise [UnknownFormat, AppendNotSupported]
      #   * {UnknownFormat} - the given format was not `:gzip`, `:bzip2`, `:xz`,
      #     or `:zip`.
      #   * {AppendNotSupported} - the `zip` archive format does not support
      #     appending to existing files within existing archives.
      #
      def self.command(path, format: , append: false)
        case format
        when :gzip, :bzip2, :xz
          command  = format.to_s
          redirect = if append then '>>'
                     else           '>'
                     end

          "#{command} #{redirect} #{Shellwords.shellescape(path)}"
        when :zip
          if append
            raise(AppendNotSupported,"zip format does not support appending to files within pre-existing archives: #{path.inspect}")
          end

          "zip -q #{Shellwords.shellescape(path)} -"
        when :"7zip"
          if append
            raise(AppendNotSupported,"7zip format does not support appending to files within pre-existing archives: #{path.inspect}")
          end

          "7za a -si #{Shellwords.shellescape(path)} >/dev/null"
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
      #   The given format was not `:gzip`, `:bzip2`, `:xz`, `:zip`.
      #
      # @raise [CommandNotFound]
      #   The `gzip`, `bzip2,` `xz`, or `zip` command was not found on the
      #   system.
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
