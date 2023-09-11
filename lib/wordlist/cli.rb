# frozen_string_literal: true
require 'wordlist/file'
require 'wordlist/builder'
require 'wordlist/version'

require 'optparse'

module Wordlist
  #
  # Represents the `wordlist` command's logic.
  #
  # @api private
  #
  # @since 1.0.0
  #
  class CLI

    # The program name.
    PROGRAM_NAME = "wordlist"

    # The URL to report bugs to.
    BUG_REPORT_URL = "https://github.com/postmodern/wordlist.rb/issues/new"

    # Mapping of `--format` option values and `format:` Symbols.
    FORMATS = {
      'txt'  => :txt,
      'gzip' => :gzip,
      'bzip2'=> :bzip2,
      'xz'   => :xz,
      'zip'  => :zip,
      '7zip' => :"7zip"
    }

    # The command's option parser.
    #
    # @return [OptionParser]
    attr_reader :option_parser

    # Command mode (building or reading).
    #
    # @return [:build, :read]
    attr_reader :mode

    # The explicit wordlist format to use.
    #
    # @return [:txt, :gzip, :bzip2, :xz, nil]
    attr_reader :format

    # The path to the output wordlist file.
    #
    # @return [String, nil]
    attr_reader :output

    # The command to run with each word from the wordlist.
    #
    # @return [String, nil]
    attr_reader :command

    # Wordlist operators to apply.
    #
    # @return [Array<(Symbol, ...)>]
    attr_reader :operators

    # Wordlist modifiers to apply.
    #
    # @return [Array<(Symbol, ...)>]
    attr_reader :modifiers

    # Additional options for {Builder#initialize}.
    #
    # @return [Hash{Symbol => Object}]
    attr_reader :builder_options

    #
    # Initializes the command.
    #
    # @param [:read, :build] mode
    #
    # @param [:txt, :gzip, :bzip2, :xz, nil] format
    #
    # @param [String, nil] command
    #
    def initialize(mode: :read, format: nil, command: nil)
      @option_parser = option_parser

      @mode    = mode
      @format  = format
      @command = command
      @output  = nil

      @operators = []
      @modifiers = []

      @builder_options = {}
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
    # @return [Wordlist::File]
    #   The opened wordlist.
    #
    def open_wordlist(path)
      if @format
        Wordlist::File.open(path, format: @format)
      else
        Wordlist::File.open(path)
      end
    rescue WordlistNotFound, UnknownFormat => error
      print_error(error.message)
      exit -1
    end

    #
    # Initializes and runs the command.
    #
    # @param [Array<String>] argv
    #   Command-line arguments.
    #
    # @return [Integer]
    #   The exit status of the command.
    #
    def self.run(argv=ARGV)
      new().run(argv)
    rescue Interrupt
      # https://tldp.org/LDP/abs/html/exitcodes.html
      return 130
    rescue Errno::EPIPE
      # STDOUT pipe broken
      return 0
    end

    #
    # Runs the command.
    #
    # @param [Array<String>] argv
    #   Command-line arguments.
    #
    # @return [Integer]
    #   The return status code.
    #
    def run(argv=ARGV)
      argv = begin
               @option_parser.parse(argv)
             rescue OptionParser::ParseError => error
               print_error(error.message)
               return -1
             end

      case @mode
      when :build then build_mode(argv)
      else             read_mode(argv)
      end
    rescue => error
      print_backtrace(error)
      return -1
    end

    #
    # Wordlist building mode.
    #
    # @param [Array<String>] argv
    #   Additional command-line arguments.
    #
    def build_mode(argv)
      builder = begin
                  if @format
                    Builder.open(@output, format: @format, **@builder_options)
                  else
                    Builder.open(@output, **@builder_options)
                  end
                rescue UnknownFormat, CommandNotFound => error
                  print_error(error.message)
                  return -1
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

      return 0
    end

    #
    # Wordlist reading mode.
    #
    # @param [Array<String>] argv
    #   Additional command-line arguments.
    #
    def read_mode(argv)
      unless argv.length >= 1
        print_error "too few arguments given, requires at least one WORDLIST argument"
        print_error "usage: #{PROGRAM_NAME} [options] WORDLIST ..."
        return -1
      end

      # open the first wodlist
      wordlist = open_wordlist(argv.first)

      # append the additional wordlists
      argv[1..].each { |arg| wordlist += (open_wordlist(arg)) }

      # apply operators first
      @operators.each do |(operator,args)|
        wordlist = wordlist.send(operator,*args)
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
        return -1
      end

      return 0
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

        opts.on('-U','--union WORDLIST','Unions the wordlist with the other WORDLIST') do |wordlist|
          add_operator(:|, open_wordlist(wordlist))
        end

        opts.on('-I','--intersect WORDLIST','Intersects the wordlist with the other WORDLIST') do |wordlist|
          add_operator(:&, open_wordlist(wordlist))
        end

        opts.on('-S','--subtract WORDLIST','Subtracts the words from the WORDLIST') do |wordlist|
          add_operator(:-, open_wordlist(wordlist))
        end

        opts.on('-p','--product WORDLIST', 'Combines every word with the other words from WORDLIST') do |wordlist|
          add_operator(:*, open_wordlist(wordlist))
        end

        opts.on('-P','--power NUM', Integer, 'Combines every word with the other words from WORDLIST') do |power|
          add_operator(:**, power)
        end

        opts.on('-u','--unique','Filters out duplicate words') do
          add_operator(:uniq)
        end

        opts.separator ""
        opts.separator "Wordlist Modifiers:"

        opts.on('-C','--capitalize','Capitalize each word') do
          add_modifier(:capitalize)
        end

        opts.on('--uppercase', '--upcase','Converts each word to UPPERCASE') do
          add_modifier(:upcase)
        end

        opts.on('--lowercase', '--downcase','Converts each word to lowercase') do
          add_modifier(:downcase)
        end

        opts.on('-t','--tr CHARS:REPLACE','Translates the characters of each word') do |string|
          chars, replace = string.split(':',2)

          add_modifier(:tr, chars, replace)
        end

        opts.on('-s','--sub PATTERN:SUB','Replaces PATTERN with SUB in each word') do |string|
          pattern, replace = string.split(':',2)

          add_modifier(:sub, pattern, replace)
        end

        opts.on('-g','--gsub PATTERN:SUB','Replaces all PATTERNs with SUB in each word') do |string|
          pattern, replace = string.split(':',2)

          add_modifier(:gsub, pattern, replace)
        end

        opts.on('-m','--mutate PATTERN:SUB','Performs every possible substitution on each word') do |string|
          pattern, replace = string.split(':',2)

          add_modifier(:mutate, pattern, replace)
        end

        opts.on('-M','--mutate-case','Switches the case of each letter in each word') do
          add_modifier(:mutate_case)
        end

        opts.separator ""
        opts.separator "Wordlist Building Options:"

        opts.on('-b','--build WORDLIST','Builds a wordlist') do |wordlist|
          @mode   = :build
          @output = wordlist
        end

        opts.on('-a', '--[no-]append', TrueClass, 'Appends to the new wordlist instead of overwriting it') do |bool|
          @builder_options[:append] = bool
        end

        opts.on('-L','--lang LANG','The language to expect') do |lang|
          @builder_options[:lang] = lang
        end

        opts.on('--stop-words WORDS...','Ignores the stop words') do |words|
          @builder_options[:stop_words] = words.split
        end

        opts.on('--ignore-words WORDS...','Ignore the words') do |words|
          @builder_options[:ignore_words] = words.split
        end

        opts.on('--[no-]digits', TrueClass, 'Allow digits in the middle of words') do |bool|
          @builder_options[:digits] = bool
        end

        opts.on('--special-chars CHARS','Allows the given special characters inside of words') do |string|
          @builder_options[:special_chars] = string.chars
        end

        opts.on('--[no-]numbers', TrueClass, 'Parses whole numbers in addition to words') do |bool|
          @builder_options[:numbers] = bool
        end

        opts.on('--[no-]acronyms', TrueClass, 'Parses acronyms in addition to words') do |bool|
          @builder_options[:acronyms] = bool
        end

        opts.on('--[no-]normalize-case', TrueClass, 'Converts all words to lowercase') do |bool|
          @builder_options[:normalize_case] = bool
        end

        opts.on('--[no-]normalize-apostrophes', TrueClass, 'Removes "\'s" from words') do |bool|
          @builder_options[:normalize_apostrophes] = bool
        end

        opts.on('--[no-]normalize-acronyms', TrueClass, 'Removes the dots from acronyms') do |bool|
          @builder_options[:normalize_acronyms] = bool
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
      $stderr.puts "Please report the following text to: #{BUG_REPORT_URL}"
      $stderr.puts
      $stderr.puts "```"
      $stderr.puts "#{exception.full_message}"
      $stderr.puts "```"
    end

  end
end
