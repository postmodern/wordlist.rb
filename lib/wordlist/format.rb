module Wordlist
  module Format
    # Mapping of file extensions to formats
    FILE_FORMATS = {
      '.txt' => :txt,
      '.gz'  => :gzip,
      '.bz2' => :bzip2,
      '.xz'  => :xz
    }

    #
    # Infers the format from the given file name.
    #
    # @param [String] path
    #   The path to the file.
    #
    # @return [:txt, :gzip, :bzip2, :xz]
    #
    def self.infer(path)
      FILE_FORMATS.fetch(File.extname(path)) do
        raise(ArgumentError,"could not infer the format of file: #{path.inspect}")
      end
    end
  end
end
