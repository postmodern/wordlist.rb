require 'wordlist/list'
require 'wordlist/builder'
require 'wordlist/version'

require 'optparse'

module Wordlist
  class CLI

    PROGRAM_NAME = "wordlist"

    BUG_REPORT_URL = "https://github.com/postmodern/wordlist.rb/issues/new"

    FORMATS = {
      'txt'  => :txt,
      'gzip' => :gzip,
      'bz2'  => :bz2,
      'xz'   => :xz
    }

    # The command's option parser.
    #
    # @return [OptionParser]
    attr_reader :option_parser

    # Command mode (building or reading).
    #
    # @return [:build, :read]
    attr_reader :mode

    # The command to run with each word from the wodlist.
    #
    # @return [String, nil]
    attr_reader :command

    #
    # Initializes the command.
    #
    def initialize
      @option_parser = option_parser

      @mode    = :read
      @command = nil

      @operators = []
      @modifiers = []
    end

    #
    # Adds an operator to be applied to the wordlist(s) later.
    #
    # @param [Symbol] name
    #   The operator method name.
    #
    # @param [Array<Object>] args
    #   Additional arguments for the operator.
    #
    def add_operator(name,*args)
      @operators << [name, args]
    end

    #
    # Adds a modifier to be applied to the wordlist(s) later.
    #
    # @param [Symbol] name
    #   The modifier method name.
    #
    # @param [Array<Object>] args
    #   Additional arguments for the modifier.
    #
    def add_modifier(name,*args)
      @modifiers << [name, args]
    end

    #
    # Opens a wordlist file.
    #
    # @param [String] path
    #   The path to the wordlist file.
    #
    # @return [List]
    #   The opened wordlist.
    #
    def open_wordlist(path)
      if @format
        List.open(path, format: @format)
      else
        List.open(path)
      end
    rescue WordlistNotFound, UnknownFormat
      print_error(error.message)
      exit -1
    end

    #
    # Initializes and runs the command.
    #
    # @param [Array<String>] argv
    #   Command-line arguments.
    #
    def self.run(argv=ARGV)
      new().run(argv)
    rescue Interrupt
      # https://tldp.org/LDP/abs/html/exitcodes.html
      exit 130
    rescue Errno::EPIPE
      # STDOUT pipe broken
      exit 0
    rescue => error
      print_backrace(error)
      exit -1
    end

    #
    # Runs the command.
    #
    # @param [Array<String>] argv
    #   Command-line arguments.
    #
    def run(argv=ARGV)
      argv = @option_parser.parse(argv)

      case @mode
      when :build then build_mode(argv)
      else             read_mode(argv)
      end
    end

    #
    # Wordlist building mode.
    #
    # @param [Array<String>] argv
    #   Additional command-line arguments.
    #
    def build_mode(argv)
      builder = if @format
                  Builder.open(@output, format: @format)
                else
                  Builder.open(@output)
                end

      begin
        if argv.empty?
          $stdin.each_line do |line|
            builder.parse(line)
          end
        else
          argv.each do |file|
            builder.parse_file(file)
          end
        end
      ensure
        builder.close
      end
    rescue UnknownFormat, CommandNotFound => error
      print_error(error.message)
      exit -1
    end

    #
    # Wordlist reading mode.
    #
    # @param [Array<String>] argv
    #   Additional command-line arguments.
    #
    def read_mode(argv)
      # open the first wodlist
      wordlist = open_wordlist(argv.first)

      # append the additional wordlists
      argv[1..].each { |arg| wordlist += (open_wordlist(arg)) }

      # apply operators first
      @operators.each do |(operator,args)|
        wordlist.send(operator,*args)
      end

      # then apply modifiers
      @modifiers.each do |(method,args)|
        wordlist = wordlist.send(method,*args)
      end

      begin
        if @command
          wordlist.each do |word|
            system(@command.gsub('{}',word))
          end
        else
          wordlist.each do |word|
            puts word
          end
        end
      rescue CommandNotFound => error
        print_error(error.message)
        exit -1
      end
    end

    #
    # The option parser.
    #
    # @return [OptionParser]
    #
    def option_parser
      OptionParser.new do |opts|
        opts.banner = "usage: #{PROGRAM_NAME} { [options] WORDLIST ... | --build WORDLIST [FILE ...] }"

        opts.separator ""
        opts.separator "Wordlist Reading Options:"

        opts.on('-f','--format {txt|gzip|bz2|xz}', FORMATS, 'Saves the output to FILE') do |format|
          @format = format
        end

        opts.on('--exec COMMAND','Runs the command with each word from the wordlist.', 'The string "{}" will be replaced with each word.') do |command|
          @command = command
        end

        opts.separator ""
        opts.separator "Wordlist Operations:"

        opts.on('-U','--union WORDLIST') do |wordlist|
          add_operator(:|, open_wordlist(wordlist))
        end

        opts.on('-I','--intersect WORDLIST') do |wordlist|
          add_operator(:&, open_wordlist(wordlist))
        end

        opts.on('-S','--subtract WORDLIST') do |wordlist|
          add_operator(:-, open_wordlist(wordlist))
        end

        opts.on('-p','--product WORDLIST', 'Combines every word from the wordlist with another wordlist') do |wordlist|
          add_operator(:*, open_wordlist(wordlist))
        end

        opts.on('-P','--power NUM', Integer, 'Combines every word from the wordlist with another wordlist') do |power|
          add_operator(:**, power)
        end

        opts.on('-u','--unique') do
          add_operator(:uniq)
        end

        opts.separator ""
        opts.separator "Wordlist Modifiers:"

        opts.on('-C','--capitalize') do
          add_modifier(:capitalize)
        end

        opts.on('--uppercase', '--upcase') do
          add_modifier(:upcase)
        end

        opts.on('--lowercase', '--downcase') do
          add_modifier(:downcase)
        end

        opts.on('-t','--tr CHARS:REPLACE') do |string|
          chars, replace = string.split(':',2)

          add_modifier(:tr, chars, replace)
        end

        opts.on('-s','--sub PATTERN:SUB') do |string|
          pattern, replace = string.split(':',2)

          add_modifier(:sub, pattern, replace)
        end

        opts.on('-g','--gsub PATTERN:SUB') do |string|
          pattern, replace = string.split(':',2)

          add_modifier(:gsub, pattern, replace)
        end

        opts.on('-m','--mutate PATTERN:SUB') do |string|
          pattern, replace = string.split(':',2)

          add_modifier(:mutate, pattern, replace)
        end

        opts.on('-M','--mutate-case') do
          add_modifier(:mutate_case)
        end

        opts.separator ""
        opts.separator "Wordlist Building Options:"

        opts.on('-b','--build WORDLIST','Builds a wordlist') do |wordlist|
          @mode   = :build
          @output = wordlist
        end

        opts.separator ""
        opts.separator "General Options:"

        opts.on('-V','--version','Print the version') do
          puts "#{PROGRAM_NAME} #{VERSION}"
          exit
        end

        opts.on('-h','--help','Print the help output') do
          puts opts
          exit
        end

        opts.separator ""
        opts.separator "Examples:"
        opts.separator "    #{PROGRAM_NAME} rockyou.txt.gz"
        opts.separator "    #{PROGRAM_NAME} passwords_short.txt passwords_long.txt"
        opts.separator "    #{PROGRAM_NAME} sport_teams.txt -p beers.txt -p digits.txt"
        opts.separator "    cat *.txt | #{PROGRAM_NAME} --build custom.txt"
        opts.separator ""
      end
    end

    #
    # Prints an error message to stderr.
    #
    # @param [String] error
    #   The error message.
    #
    def print_error(error)
      $stderr.puts "#{PROGRAM_NAME}: #{error}"
    end

    #
    # Prints a backtrace to stderr.
    #
    # @param [Exception] exception
    #   The exception.
    #
    def print_backtrace(exception)
      $stderr.puts "Oops! Looks like you've found a bug!"
      $stderr.puts "Please report the following to: #{BUG_REPORT_URL}"
      $stderr.puts
      $stderr.puts "```"
      $stderr.puts "#{exception.full_message}"
      $stderr.puts "```"
    end

  end
end
