require 'spec_helper'
require 'wordlist/cli'

describe Wordlist::CLI do
  describe "#initialize" do
    it "must default #mode to :read" do
      expect(subject.mode).to eq(:read)
    end

    it "must default #format to nil" do
      expect(subject.format).to be(nil)
    end

    it "must default #command to nil" do
      expect(subject.command).to be(nil)
    end

    it "must default #output to nil" do
      expect(subject.output).to be(nil)
    end

    it "must initialize #option_parser" do
      expect(subject.option_parser).to be_kind_of(OptionParser)
    end

    it "must initialize #operators to []" do
      expect(subject.operators).to eq([])
    end

    it "must initialize #modifiers to []" do
      expect(subject.modifiers).to eq([])
    end

    it "must initialize #build_options to {}" do
      expect(subject.builder_options).to eq({})
    end
  end

  describe "#print_error" do
    let(:error) { "error!" }

    it "must print the program name and the error message to stderr" do
      expect {
        subject.print_error(error)
      }.to output("#{described_class::PROGRAM_NAME}: #{error}#{$/}").to_stderr
    end
  end

  describe "#print_backtrace" do
    let(:exception) { RuntimeError.new("error!") }

    it "must print the program name and the error message to stderr" do
      expect {
        subject.print_backtrace(exception)
      }.to output(
        %r{Oops! Looks like you've found a bug!
Please report the following text to: #{Regexp.escape(described_class::BUG_REPORT_URL)}

```}m
      ).to_stderr
    end
  end

  let(:fixtures_dir) { File.join(__dir__,'fixtures') }

  describe "#open_wordlist" do
    context "when #format is set" do
      let(:format) { :gzip }
      let(:path)   { ::File.join(fixtures_dir,'wordlist_with_ambiguous_format') }

      subject { described_class.new(format: format) }

      it "must call Wordlist::File.new with a format: keyword argument" do
        wordlist = subject.open_wordlist(path)

        expect(wordlist.format).to be(format)
      end
    end

    context "when #format is not set" do
      let(:path) { ::File.join(fixtures_dir,'wordlist.txt.gz') }

      it "must let Wordlist::File.new infer the format" do
        wordlist = subject.open_wordlist(path)

        expect(wordlist.format).to be(:gzip)
      end

      context "and the file's format cannot be inferred" do
        let(:path)   { ::File.join(fixtures_dir,'wordlist_with_ambiguous_format') }

        it "must print an error and exit with -1" do
          expect(subject).to receive(:exit).with(-1)

          expect {
            subject.open_wordlist(path)
          }.to output("#{described_class::PROGRAM_NAME}: could not infer the format of file: #{path.inspect}#{$/}").to_stderr
        end
      end
    end

    context "when the file does not exist" do
      let(:path) { 'does/not/exist.txt' }

      it "must print an error and exit with -1" do
        expect(subject).to receive(:exit).with(-1)

        expect {
          subject.open_wordlist(path)
        }.to output("#{described_class::PROGRAM_NAME}: wordlist file does not exist: #{path.inspect}#{$/}").to_stderr
      end
    end
  end

  describe "#add_operator" do
    let(:op1) { :+ }
    let(:wordlist1) { double(:other_wordlist1) }

    let(:op2) { :* }
    let(:wordlist2) { double(:other_wordlist2) }

    before do
      subject.add_operator(op1, wordlist1)
      subject.add_operator(op2, wordlist2)
    end

    it "must append an operator and it's arguments to #operators" do
      expect(subject.operators[0]).to be_a(Array)
      expect(subject.operators[0][0]).to eq(op1)
      expect(subject.operators[0][1]).to eq([wordlist1])

      expect(subject.operators[1]).to be_a(Array)
      expect(subject.operators[1][0]).to eq(op2)
      expect(subject.operators[1][1]).to eq([wordlist2])
    end
  end

  describe "#add_modifier" do
    let(:mod1)  { :capitalize }
    let(:args1) { [] }

    let(:mod2)  { :gsub }
    let(:args2) { ['e','3'] }

    before do
      subject.add_modifier(mod1, *args1)
      subject.add_modifier(mod2, *args2)
    end

    it "must append an modifier and it's arguments to #modifiers" do
      expect(subject.modifiers[0]).to be_a(Array)
      expect(subject.modifiers[0][0]).to eq(mod1)
      expect(subject.modifiers[0][1]).to eq(args1)

      expect(subject.modifiers[1]).to be_a(Array)
      expect(subject.modifiers[1][0]).to eq(mod2)
      expect(subject.modifiers[1][1]).to eq(args2)
    end
  end

  describe "#option_parser" do
    it do
      expect(subject.option_parser).to be_kind_of(OptionParser)
    end

    describe "#parse" do
      context "when given -f FORMAT" do
        let(:format) { :gzip }
        let(:argv)   { ['-f', format.to_s] }

        before { subject.option_parser.parse(argv) }

        it "must set #format" do
          expect(subject.format).to eq(format)
        end
      end

      context "when given --format FORMAT" do
        let(:format) { :gzip }
        let(:argv)   { ['--format', format.to_s] }

        before { subject.option_parser.parse(argv) }

        it "must set #format" do
          expect(subject.format).to eq(format)
        end
      end

      context "when given --exec COMMAND" do
        let(:command) { "foo {}" }
        let(:argv)    { ['--exec', command] }

        before { subject.option_parser.parse(argv) }

        it "must set #command" do
          expect(subject.command).to eq(command)
        end
      end

      %w[-U --union].each do |flag|
        context "when given #{flag} WORDLIST" do
          let(:wordlist) { File.join(fixtures_dir,'wordlist.txt.gz') }
          let(:argv)     { [flag, wordlist] }

          before { subject.option_parser.parse(argv) }

          it "must append to #operators" do
            expect(subject.operators.length).to be(1)
            expect(subject.operators[0][0]).to be(:|)
            expect(subject.operators[0][1].length).to be(1)
            expect(subject.operators[0][1][0]).to be_kind_of(Wordlist::File)
            expect(subject.operators[0][1][0].path).to eq(wordlist)
          end
        end
      end

      %w[-I --intersect].each do |flag|
        context "when given #{flag} WORDLIST" do
          let(:wordlist) { File.join(fixtures_dir,'wordlist.txt.gz') }
          let(:argv)     { [flag, wordlist] }

          before { subject.option_parser.parse(argv) }

          it "must append to #operators" do
            expect(subject.operators.length).to be(1)
            expect(subject.operators[0][0]).to be(:&)
            expect(subject.operators[0][1].length).to be(1)
            expect(subject.operators[0][1][0]).to be_kind_of(Wordlist::File)
            expect(subject.operators[0][1][0].path).to eq(wordlist)
          end
        end
      end

      %w[-S --subtract].each do |flag|
        context "when given #{flag} WORDLIST" do
          let(:wordlist) { File.join(fixtures_dir,'wordlist.txt.gz') }
          let(:argv)     { [flag, wordlist] }

          before { subject.option_parser.parse(argv) }

          it "must append to #operators" do
            expect(subject.operators.length).to be(1)
            expect(subject.operators[0][0]).to be(:-)
            expect(subject.operators[0][1].length).to be(1)
            expect(subject.operators[0][1][0]).to be_kind_of(Wordlist::File)
            expect(subject.operators[0][1][0].path).to eq(wordlist)
          end
        end
      end

      %w[-p --product].each do |flag|
        context "when given #{flag} WORDLIST" do
          let(:wordlist) { File.join(fixtures_dir,'wordlist.txt.gz') }
          let(:argv)     { [flag, wordlist] }

          before { subject.option_parser.parse(argv) }

          it "must append to #operators" do
            expect(subject.operators.length).to be(1)
            expect(subject.operators[0][0]).to be(:*)
            expect(subject.operators[0][1].length).to be(1)
            expect(subject.operators[0][1][0]).to be_kind_of(Wordlist::File)
            expect(subject.operators[0][1][0].path).to eq(wordlist)
          end
        end
      end

      %w[-P --power].each do |flag|
        context "when given #{flag} POWER" do
          let(:power) { 3 }
          let(:argv)  { [flag, power.to_s] }

          before { subject.option_parser.parse(argv) }

          it "must append to #operators" do
            expect(subject.operators.length).to be(1)
            expect(subject.operators[0][0]).to be(:**)
            expect(subject.operators[0][1].length).to be(1)
            expect(subject.operators[0][1][0]).to be(power)
          end
        end
      end

      %w[-u --unique].each do |flag|
        context "when given #{flag}" do
          let(:argv) { [flag] }

          before { subject.option_parser.parse(argv) }

          it "must append to #operators" do
            expect(subject.operators.length).to be(1)
            expect(subject.operators[0][0]).to be(:uniq)
            expect(subject.operators[0][1].length).to be(0)
          end
        end
      end

      %w[-C --capitalize].each do |flag|
        context "when given #{flag}" do
          let(:argv) { [flag] }

          before { subject.option_parser.parse(argv) }

          it "must append to #modifiers" do
            expect(subject.modifiers.length).to be(1)
            expect(subject.modifiers[0][0]).to be(:capitalize)
            expect(subject.modifiers[0][1].length).to be(0)
          end
        end
      end

      %w[--uppercase --upcase].each do |flag|
        context "when given #{flag} WORDLIST" do
          let(:wordlist) { File.join(fixtures_dir,'wordlist.txt.gz') }
          let(:argv)     { [flag, wordlist] }

          before { subject.option_parser.parse(argv) }

          it "must append to #modifiers" do
            expect(subject.modifiers.length).to be(1)
            expect(subject.modifiers[0][0]).to be(:upcase)
            expect(subject.modifiers[0][1].length).to be(0)
          end
        end
      end

      %w[--lowercase --downcase].each do |flag|
        context "when given #{flag} WORDLIST" do
          let(:wordlist) { File.join(fixtures_dir,'wordlist.txt.gz') }
          let(:argv)     { [flag, wordlist] }

          before { subject.option_parser.parse(argv) }

          it "must append to #modifiers" do
            expect(subject.modifiers.length).to be(1)
            expect(subject.modifiers[0][0]).to be(:downcase)
            expect(subject.modifiers[0][1].length).to be(0)
          end
        end
      end

      %w[-t --tr].each do |flag|
        context "when given #{flag} CHARS:REPLACE" do
          let(:chars)   { 'e' }
          let(:replace) { '3' }
          let(:argv)    { [flag, "#{chars}:#{replace}"] }

          before { subject.option_parser.parse(argv) }

          it "must append to #modifiers" do
            expect(subject.modifiers.length).to be(1)
            expect(subject.modifiers[0][0]).to be(:tr)
            expect(subject.modifiers[0][1].length).to be(2)
            expect(subject.modifiers[0][1][0]).to eq(chars)
            expect(subject.modifiers[0][1][1]).to eq(replace)
          end
        end
      end

      %w[-s --sub].each do |flag|
        context "when given #{flag} CHARS:REPLACE" do
          let(:chars)   { 'e' }
          let(:replace) { '3' }
          let(:argv)    { [flag, "#{chars}:#{replace}"] }

          before { subject.option_parser.parse(argv) }

          it "must append to #modifiers" do
            expect(subject.modifiers.length).to be(1)
            expect(subject.modifiers[0][0]).to be(:sub)
            expect(subject.modifiers[0][1].length).to be(2)
            expect(subject.modifiers[0][1][0]).to eq(chars)
            expect(subject.modifiers[0][1][1]).to eq(replace)
          end
        end
      end

      %w[-g --gsub].each do |flag|
        context "when given #{flag} CHARS:REPLACE" do
          let(:chars)   { 'e' }
          let(:replace) { '3' }
          let(:argv)    { [flag, "#{chars}:#{replace}"] }

          before { subject.option_parser.parse(argv) }

          it "must append to #modifiers" do
            expect(subject.modifiers.length).to be(1)
            expect(subject.modifiers[0][0]).to be(:gsub)
            expect(subject.modifiers[0][1].length).to be(2)
            expect(subject.modifiers[0][1][0]).to eq(chars)
            expect(subject.modifiers[0][1][1]).to eq(replace)
          end
        end
      end

      %w[-m --mutate].each do |flag|
        context "when given #{flag} CHARS:REPLACE" do
          let(:chars)   { 'e' }
          let(:replace) { '3' }
          let(:argv)    { [flag, "#{chars}:#{replace}"] }

          before { subject.option_parser.parse(argv) }

          it "must append to #modifiers" do
            expect(subject.modifiers.length).to be(1)
            expect(subject.modifiers[0][0]).to be(:mutate)
            expect(subject.modifiers[0][1].length).to be(2)
            expect(subject.modifiers[0][1][0]).to eq(chars)
            expect(subject.modifiers[0][1][1]).to eq(replace)
          end
        end
      end

      %w[-M --mutate-case].each do |flag|
        context "when given #{flag}" do
          let(:argv) { [flag] }

          before { subject.option_parser.parse(argv) }

          it "must append to #modifiers" do
            expect(subject.modifiers.length).to be(1)
            expect(subject.modifiers[0][0]).to be(:mutate_case)
            expect(subject.modifiers[0][1].length).to be(0)
          end
        end
      end

      %w[-b --build].each do |flag|
        context "when given #{flag} WORDLIST" do
          let(:wordlist) { File.join(fixtures_dir,'new_wordlist.txt') }
          let(:argv)     { [flag, wordlist] }

          before { subject.option_parser.parse(argv) }

          it "must append to #modifiers" do
            expect(subject.mode).to eq(:build)
            expect(subject.output).to eq(wordlist)
          end
        end
      end

      %w[-a --append].each do |flag|
        context "when given #{flag}" do
          let(:argv) { [flag] }

          before { subject.option_parser.parse(argv) }

          it "must set #builder_options[:append] to true" do
            expect(subject.builder_options[:append]).to be(true)
          end

          context "and when given --no-append" do
            let(:argv) { ['--append', '--no-append'] }

            it "must set #builder_options[:append] to false" do
              expect(subject.builder_options[:append]).to be(false)
            end
          end
        end
      end

      %w[-L --lang].each do |flag|
        context "when given #{flag} LANG" do
          let(:lang) { 'fr' }
          let(:argv) { [flag, lang] }

          before { subject.option_parser.parse(argv) }

          it "must set #builder_options[:lang] to LANG" do
            expect(subject.builder_options[:lang]).to eq(lang)
          end
        end
      end

      context "when given --stop-words \"WORDS...\"" do
        let(:words) { "foo bar baz" }
        let(:argv)  { ['--stop-words', words] }

        before { subject.option_parser.parse(argv) }

        it "must set #builder_options[:stop_words] to the Array of WORDS" do
          expect(subject.builder_options[:stop_words]).to eq(words.split)
        end
      end

      context "when given --ignore-words \"WORDS...\"" do
        let(:words) { "foo bar baz" }
        let(:argv)  { ['--ignore-words', words] }

        before { subject.option_parser.parse(argv) }

        it "must set #builder_options[:ignore_words] to the Array of WORDS" do
          expect(subject.builder_options[:ignore_words]).to eq(words.split)
        end
      end

      context "when given --digits" do
        let(:argv) { ['--digits'] }

        before { subject.option_parser.parse(argv) }

        it "must set #builder_options[:digits] to true" do
          expect(subject.builder_options[:digits]).to be(true)
        end

        context "and when given --no-digits" do
          let(:argv) { ['--digits', '--no-digits'] }

          it "must set #builder_options[:digits] to false" do
            expect(subject.builder_options[:digits]).to be(false)
          end
        end
      end

      context "when given --special-chars \"CHARS...\"" do
        let(:chars) { "!@#$%^&*()_-" }
        let(:argv)  { ['--special-chars', chars] }

        before { subject.option_parser.parse(argv) }

        it "must set #builder_options[:special_chars] to the Array of CHARS" do
          expect(subject.builder_options[:special_chars]).to eq(chars.chars)
        end
      end

      context "when given --numbers" do
        let(:argv) { ['--numbers'] }

        before { subject.option_parser.parse(argv) }

        it "must set #builder_options[:numbers] to true" do
          expect(subject.builder_options[:numbers]).to be(true)
        end

        context "and when given --no-numbers" do
          let(:argv) { ['--numbers', '--no-numbers'] }

          it "must set #builder_options[:numbers] to false" do
            expect(subject.builder_options[:numbers]).to be(false)
          end
        end
      end

      context "when given --acronyms" do
        let(:argv) { ['--acronyms'] }

        before { subject.option_parser.parse(argv) }

        it "must set #builder_options[:acronyms] to true" do
          expect(subject.builder_options[:acronyms]).to be(true)
        end

        context "and when given --no-acronyms" do
          let(:argv) { ['--acronyms', '--no-acronyms'] }

          it "must set #builder_options[:acronyms] to false" do
            expect(subject.builder_options[:acronyms]).to be(false)
          end
        end
      end

      context "when given --normalize-case" do
        let(:argv) { ['--normalize-case'] }

        before { subject.option_parser.parse(argv) }

        it "must set #builder_options[:normalize_case] to true" do
          expect(subject.builder_options[:normalize_case]).to be(true)
        end

        context "and when given --no-normalize-case" do
          let(:argv) { ['--normalize-case', '--no-normalize-case'] }

          it "must set #builder_options[:normalize_case] to false" do
            expect(subject.builder_options[:normalize_case]).to be(false)
          end
        end
      end

      context "when given --normalize-apostrophes" do
        let(:argv) { ['--normalize-apostrophes'] }

        before { subject.option_parser.parse(argv) }

        it "must set #builder_options[:normalize_apostrophes] to true" do
          expect(subject.builder_options[:normalize_apostrophes]).to be(true)
        end

        context "and when given --no-normalize-apostrophes" do
          let(:argv) { ['--normalize-apostrophes', '--no-normalize-apostrophes'] }

          it "must set #builder_options[:normalize_apostrophes] to false" do
            expect(subject.builder_options[:normalize_apostrophes]).to be(false)
          end
        end
      end

      context "when given --normalize-acronyms" do
        let(:argv) { ['--normalize-acronyms'] }

        before { subject.option_parser.parse(argv) }

        it "must set #builder_options[:normalize_acronyms] to true" do
          expect(subject.builder_options[:normalize_acronyms]).to be(true)
        end

        context "and when given --no-normalize-acronyms" do
          let(:argv) { ['--normalize-acronyms', '--no-normalize-acronyms'] }

          it "must set #builder_options[:normalize_acronyms] to false" do
            expect(subject.builder_options[:normalize_acronyms]).to be(false)
          end
        end
      end

      %w[-V --version].each do |flag|
        context "when given #{flag}" do
          let(:argv) { [flag] }

          it "must append to #modifiers" do
            expect(subject).to receive(:exit)

            expect {
              subject.option_parser.parse(argv)
            }.to output("#{described_class::PROGRAM_NAME} #{Wordlist::VERSION}#{$/}").to_stdout
          end
        end
      end

      %w[-h --help].each do |flag|
        context "when given #{flag}" do
          let(:argv) { [flag] }

          it "must append to #modifiers" do
            expect(subject).to receive(:exit)

            expect {
              subject.option_parser.parse(argv)
            }.to output("#{subject.option_parser}").to_stdout
          end
        end
      end
    end
  end

  describe ".run" do
    subject { described_class }

    context "when Interrupt is raised" do
      before do
        expect_any_instance_of(described_class).to receive(:run).and_raise(Interrupt)
      end

      it "must exit with 130" do
        expect(subject.run([])).to eq(130)
      end
    end

    context "when Errno::EPIPE is raised" do
      before do
        expect_any_instance_of(described_class).to receive(:run).and_raise(Errno::EPIPE)
      end

      it "must exit with 0" do
        expect(subject.run([])).to eq(0)
      end
    end
  end

  describe "#run" do
    context "when given a wordlist file" do
      let(:file) { ::File.join(fixtures_dir,'wordlist.txt') }
      let(:argv) { [file] }

      let(:expected_words) { File.readlines(file).map(&:chomp) }

      it "must read each word from the file and print it to stdout" do
        expect {
          subject.run(argv)
        }.to output(
          expected_words.join($/) + $/
        ).to_stdout
      end

      context "when also given the --exec COMMAND option" do
        let(:command) { 'echo "WORD: {}"' }
        let(:argv)    { ["--exec", command, file] }

        let(:expected_output) do
          expected_words.map do |word|
          end
        end

        it "must execute the command with each word from the wordlist" do
          expected_words.each do |word|
            expect(subject).to receive(:system).with(command.sub('{}',word))
          end

          subject.run(argv)
        end
      end
    end

    context "when given the --build option" do
      let(:expected_words) { %w[foo bar baz qux] }
      let(:text) { (expected_words * 100).shuffle.join(' ') }

      let(:output) { File.join(fixtures_dir,'new_wordlist.txt') }

      context "and given one input file" do
        let(:input) { File.join(fixtures_dir,"input_file.txt") }
        let(:argv)  { ["--build", output, input] }

        before { File.write(input,text) }

        it "must build a new wordlist file based on the given file" do
          subject.run(argv)

          expect(File.readlines(output).map(&:chomp)).to match_array(expected_words)
        end

        after { FileUtils.rm_f(input) }
      end

      context "and given multiple input files" do
        let(:words) { (expected_words * 100).shuffle }
        let(:text1) { words[0,50]  }
        let(:text2) { words[50,50] }

        let(:input1) { File.join(fixtures_dir,"input_file1.txt") }
        let(:input2) { File.join(fixtures_dir,"input_file2.txt") }
        let(:argv)   { ["--build", output, input1, input2] }

        before do
          File.write(input1,text1)
          File.write(input2,text2)
        end

        it "must build a new wordlist file based on the given files" do
          subject.run(argv)

          expect(File.readlines(output).map(&:chomp)).to match_array(expected_words)
        end

        after do
          FileUtils.rm_f(input1)
          FileUtils.rm_f(input2)
        end
      end

      context "and given no input files" do
        let(:argv) { ["--build", output] }

        before do
          $stdin = StringIO.new(text)
        end

        it "must build a new wordlist file by reading stdin" do
          subject.run(argv)

          expect(File.readlines(output).map(&:chomp)).to match_array(expected_words)
        end

        after do
          $stdin = STDIN
        end
      end

      after { FileUtils.rm_f(output) }
    end

    context "when an invalid option is given" do
      let(:opt) { '--foo' }

      it "must print 'wordlist: invalid option ...' to $stderr and exit with -1" do
        expect {
          expect(subject.run([opt])).to eq(-1)
        }.to output("wordlist: invalid option: #{opt}#{$/}").to_stderr
      end
    end

    context "when another type of Exception is raised" do
      let(:exception) { RuntimeError.new("error!") }

      before do
        expect(subject).to receive(:read_mode).and_raise(exception)
      end

      it "must print a backtrace and exit with -1" do
        expect {
          expect(subject.run([])).to eq(-1)
        }.to output(
          %r{Oops! Looks like you've found a bug!
Please report the following text to: #{Regexp.escape(described_class::BUG_REPORT_URL)}

```}m
        ).to_stderr
      end
    end
  end
end
