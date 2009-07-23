require 'wordlist/source'

module Wordlist
  class File < Source

    def initialize(path,options={})
      @path = path

      super(options)
    end

    def each_word(&block)
      ::File.open(@path) do |file|
        file.each_line do |line|
          line.split.each(&block)
        end
      end
    end

  end
end
