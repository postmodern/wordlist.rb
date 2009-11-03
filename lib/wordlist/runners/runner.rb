require 'optparse'

module Wordlist
  module Runners
    class Runner
      #
      # Creates and runs the runner with the given _args_.
      #
      def self.run(*args)
        runner = self.new
        runner.run(*args)
      end

      #
      # Runs the runner with the given _args_.
      #
      def run(*args)
        optparse(*args)
      end

      protected

      #
      # Prints the specified error _message_.
      #
      def print_error(message)
        STDERR.puts "#{$0}: #{message}"
      end

      #
      # Parses the given _args_.
      #
      def optparse(*args,&block)
        opts = OptionParser.new
        block.call(opts) if block

        begin
          opts.parse!(args)
        rescue OptionParser::InvalidOption => e
          STDERR.puts e.message
          STDERR.puts opts
          exit -1
        end
      end
    end
  end
end
