require_relative '../exceptions'

require 'shellwords'

module Wordlist
  module Compression
    #
    # Handles reading compressed files.
    #
    # @since 1.0.0
    #
    module Reader
      #
      # Returns the command to read the compressed wordlist.
      #
      # @param [String] path
      #   The path to the file.
      #
      # @param [:gzip, :bzip2, :xz, :zip, :7zip] format
      #   The compression format of the file.
      #
      # @return [String]
      #   The shellescaped command string.
      #
      # @raise [UnknownFormat]
      #   The given format was not `:gzip`, `:bzip2`, `:xz`, `:zip`, `:7zip`.
      #
      def self.command(path, format: )
        case format
        when :gzip   then "zcat < #{Shellwords.shellescape(path)}"
        when :bzip2  then "bzcat < #{Shellwords.shellescape(path)}"
        when :xz     then "xzcat < #{Shellwords.shellescape(path)}"
        when :zip    then "unzip -p #{Shellwords.shellescape(path)}"
        when :"7zip" then "7za e -so #{Shellwords.shellescape(path)}"
        else
          raise(UnknownFormat,"unsupported input format: #{format.inspect}")
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
      #   The given format was not `:gzip`, `:bzip2`, `:xz`, `:zip`, or `:7zip`.
      #
      # @raise [CommandNotFound]
      #   The `zcat,` `bzcat`, `xzcat`, or `unzip` command could not be found.
      #
      def self.open(path,**kwargs,&block)
        command = self.command(path,**kwargs)

        begin
          IO.popen(command,&block)
        rescue Errno::ENOENT
          raise(CommandNotFound,"#{command.inspect} command not found")
        end
      end
    end
  end
end
