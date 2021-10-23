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
      let(:path)   { ::File.join(fixtures_dir,'ambiguous_wordlist_format') }

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
        let(:path) { ::File.join(fixtures_dir,'ambiguous_wordlist_format') }

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
        }.to output("#{described_class::PROGRAM_NAME}: No such file or directory - wordlist file does not exist: #{path.inspect}#{$/}").to_stderr
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

      context "when given -U WORDLIST" do
        let(:wordlist) { File.join(fixtures_dir,'wordlist.txt.gz') }
        let(:argv)     { ['-U', wordlist] }

        before { subject.option_parser.parse(argv) }

        it "must append to #operators" do
          expect(subject.operators.length).to be(1)
          expect(subject.operators[0][0]).to be(:|)
          expect(subject.operators[0][1].length).to be(1)
          expect(subject.operators[0][1][0]).to be_kind_of(Wordlist::File)
          expect(subject.operators[0][1][0].path).to eq(wordlist)
        end
      end

      context "when given --union WORDLIST" do
        let(:wordlist) { File.join(fixtures_dir,'wordlist.txt.gz') }
        let(:argv)     { ['--union', wordlist] }

        before { subject.option_parser.parse(argv) }

        it "must append to #operators" do
          expect(subject.operators.length).to be(1)
          expect(subject.operators[0][0]).to be(:|)
          expect(subject.operators[0][1].length).to be(1)
          expect(subject.operators[0][1][0]).to be_kind_of(Wordlist::File)
          expect(subject.operators[0][1][0].path).to eq(wordlist)
        end
      end

      context "when given -I WORDLIST" do
        let(:wordlist) { File.join(fixtures_dir,'wordlist.txt.gz') }
        let(:argv)     { ['-I', wordlist] }

        before { subject.option_parser.parse(argv) }

        it "must append to #operators" do
          expect(subject.operators.length).to be(1)
          expect(subject.operators[0][0]).to be(:&)
          expect(subject.operators[0][1].length).to be(1)
          expect(subject.operators[0][1][0]).to be_kind_of(Wordlist::File)
          expect(subject.operators[0][1][0].path).to eq(wordlist)
        end
      end

      context "when given --intersect WORDLIST" do
        let(:wordlist) { File.join(fixtures_dir,'wordlist.txt.gz') }
        let(:argv)     { ['--intersect', wordlist] }

        before { subject.option_parser.parse(argv) }

        it "must append to #operators" do
          expect(subject.operators.length).to be(1)
          expect(subject.operators[0][0]).to be(:&)
          expect(subject.operators[0][1].length).to be(1)
          expect(subject.operators[0][1][0]).to be_kind_of(Wordlist::File)
          expect(subject.operators[0][1][0].path).to eq(wordlist)
        end
      end

      context "when given -S WORDLIST" do
        let(:wordlist) { File.join(fixtures_dir,'wordlist.txt.gz') }
        let(:argv)     { ['-S', wordlist] }

        before { subject.option_parser.parse(argv) }

        it "must append to #operators" do
          expect(subject.operators.length).to be(1)
          expect(subject.operators[0][0]).to be(:-)
          expect(subject.operators[0][1].length).to be(1)
          expect(subject.operators[0][1][0]).to be_kind_of(Wordlist::File)
          expect(subject.operators[0][1][0].path).to eq(wordlist)
        end
      end

      context "when given --subtract WORDLIST" do
        let(:wordlist) { File.join(fixtures_dir,'wordlist.txt.gz') }
        let(:argv)     { ['--subtract', wordlist] }

        before { subject.option_parser.parse(argv) }

        it "must append to #operators" do
          expect(subject.operators.length).to be(1)
          expect(subject.operators[0][0]).to be(:-)
          expect(subject.operators[0][1].length).to be(1)
          expect(subject.operators[0][1][0]).to be_kind_of(Wordlist::File)
          expect(subject.operators[0][1][0].path).to eq(wordlist)
        end
      end

      context "when given -p WORDLIST" do
        let(:wordlist) { File.join(fixtures_dir,'wordlist.txt.gz') }
        let(:argv)     { ['-p', wordlist] }

        before { subject.option_parser.parse(argv) }

        it "must append to #operators" do
          expect(subject.operators.length).to be(1)
          expect(subject.operators[0][0]).to be(:*)
          expect(subject.operators[0][1].length).to be(1)
          expect(subject.operators[0][1][0]).to be_kind_of(Wordlist::File)
          expect(subject.operators[0][1][0].path).to eq(wordlist)
        end
      end

      context "when given --product WORDLIST" do
        let(:wordlist) { File.join(fixtures_dir,'wordlist.txt.gz') }
        let(:argv)     { ['--product', wordlist] }

        before { subject.option_parser.parse(argv) }

        it "must append to #operators" do
          expect(subject.operators.length).to be(1)
          expect(subject.operators[0][0]).to be(:*)
          expect(subject.operators[0][1].length).to be(1)
          expect(subject.operators[0][1][0]).to be_kind_of(Wordlist::File)
          expect(subject.operators[0][1][0].path).to eq(wordlist)
        end
      end

      context "when given -P POWER" do
        let(:power) { 3 }
        let(:argv)  { ['-P', power.to_s] }

        before { subject.option_parser.parse(argv) }

        it "must append to #operators" do
          expect(subject.operators.length).to be(1)
          expect(subject.operators[0][0]).to be(:**)
          expect(subject.operators[0][1].length).to be(1)
          expect(subject.operators[0][1][0]).to be(power)
        end
      end

      context "when given --power POWER" do
        let(:power) { 3 }
        let(:argv)  { ['--power', power.to_s] }

        before { subject.option_parser.parse(argv) }

        it "must append to #operators" do
          expect(subject.operators.length).to be(1)
          expect(subject.operators[0][0]).to be(:**)
          expect(subject.operators[0][1].length).to be(1)
          expect(subject.operators[0][1][0]).to be(power)
        end
      end

      context "when given -u" do
        let(:argv) { ['-u'] }

        before { subject.option_parser.parse(argv) }

        it "must append to #operators" do
          expect(subject.operators.length).to be(1)
          expect(subject.operators[0][0]).to be(:uniq)
          expect(subject.operators[0][1].length).to be(0)
        end
      end

      context "when given --unique" do
        let(:argv) { ['--unique'] }

        before { subject.option_parser.parse(argv) }

        it "must append to #operators" do
          expect(subject.operators.length).to be(1)
          expect(subject.operators[0][0]).to be(:uniq)
          expect(subject.operators[0][1].length).to be(0)
        end
      end

      context "when given -C" do
        let(:argv) { ['-C'] }

        before { subject.option_parser.parse(argv) }

        it "must append to #modifiers" do
          expect(subject.modifiers.length).to be(1)
          expect(subject.modifiers[0][0]).to be(:capitalize)
          expect(subject.modifiers[0][1].length).to be(0)
        end
      end

      context "when given --capitalize" do
        let(:argv) { ['--capitalize'] }

        before { subject.option_parser.parse(argv) }

        it "must append to #modifiers" do
          expect(subject.modifiers.length).to be(1)
          expect(subject.modifiers[0][0]).to be(:capitalize)
          expect(subject.modifiers[0][1].length).to be(0)
        end
      end

      context "when given --uppercase WORDLIST" do
        let(:wordlist) { File.join(fixtures_dir,'wordlist.txt.gz') }
        let(:argv)     { ['--uppercase', wordlist] }

        before { subject.option_parser.parse(argv) }

        it "must append to #modifiers" do
          expect(subject.modifiers.length).to be(1)
          expect(subject.modifiers[0][0]).to be(:upcase)
          expect(subject.modifiers[0][1].length).to be(0)
        end
      end

      context "when given --upcase WORDLIST" do
        let(:wordlist) { File.join(fixtures_dir,'wordlist.txt.gz') }
        let(:argv)     { ['--upcase', wordlist] }

        before { subject.option_parser.parse(argv) }

        it "must append to #modifiers" do
          expect(subject.modifiers.length).to be(1)
          expect(subject.modifiers[0][0]).to be(:upcase)
          expect(subject.modifiers[0][1].length).to be(0)
        end
      end

      context "when given --lowercase WORDLIST" do
        let(:wordlist) { File.join(fixtures_dir,'wordlist.txt.gz') }
        let(:argv)     { ['--lowercase', wordlist] }

        before { subject.option_parser.parse(argv) }

        it "must append to #modifiers" do
          expect(subject.modifiers.length).to be(1)
          expect(subject.modifiers[0][0]).to be(:downcase)
          expect(subject.modifiers[0][1].length).to be(0)
        end
      end

      context "when given --downcase WORDLIST" do
        let(:wordlist) { File.join(fixtures_dir,'wordlist.txt.gz') }
        let(:argv)     { ['--downcase', wordlist] }

        before { subject.option_parser.parse(argv) }

        it "must append to #modifiers" do
          expect(subject.modifiers.length).to be(1)
          expect(subject.modifiers[0][0]).to be(:downcase)
          expect(subject.modifiers[0][1].length).to be(0)
        end
      end

      context "when given -t CHARS:REPLACE" do
        let(:chars)   { 'e' }
        let(:replace) { '3' }
        let(:argv)    { ['-t', "#{chars}:#{replace}"] }

        before { subject.option_parser.parse(argv) }

        it "must append to #modifiers" do
          expect(subject.modifiers.length).to be(1)
          expect(subject.modifiers[0][0]).to be(:tr)
          expect(subject.modifiers[0][1].length).to be(2)
          expect(subject.modifiers[0][1][0]).to eq(chars)
          expect(subject.modifiers[0][1][1]).to eq(replace)
        end
      end

      context "when given --tr CHARS:REPLACE" do
        let(:chars)   { 'e' }
        let(:replace) { '3' }
        let(:argv)    { ['--tr', "#{chars}:#{replace}"] }

        before { subject.option_parser.parse(argv) }

        it "must append to #modifiers" do
          expect(subject.modifiers.length).to be(1)
          expect(subject.modifiers[0][0]).to be(:tr)
          expect(subject.modifiers[0][1].length).to be(2)
          expect(subject.modifiers[0][1][0]).to eq(chars)
          expect(subject.modifiers[0][1][1]).to eq(replace)
        end
      end

      context "when given -s CHARS:REPLACE" do
        let(:chars)   { 'e' }
        let(:replace) { '3' }
        let(:argv)    { ['-s', "#{chars}:#{replace}"] }

        before { subject.option_parser.parse(argv) }

        it "must append to #modifiers" do
          expect(subject.modifiers.length).to be(1)
          expect(subject.modifiers[0][0]).to be(:sub)
          expect(subject.modifiers[0][1].length).to be(2)
          expect(subject.modifiers[0][1][0]).to eq(chars)
          expect(subject.modifiers[0][1][1]).to eq(replace)
        end
      end

      context "when given --sub CHARS:REPLACE" do
        let(:chars)   { 'e' }
        let(:replace) { '3' }
        let(:argv)    { ['--sub', "#{chars}:#{replace}"] }

        before { subject.option_parser.parse(argv) }

        it "must append to #modifiers" do
          expect(subject.modifiers.length).to be(1)
          expect(subject.modifiers[0][0]).to be(:sub)
          expect(subject.modifiers[0][1].length).to be(2)
          expect(subject.modifiers[0][1][0]).to eq(chars)
          expect(subject.modifiers[0][1][1]).to eq(replace)
        end
      end

      context "when given -g CHARS:REPLACE" do
        let(:chars)   { 'e' }
        let(:replace) { '3' }
        let(:argv)    { ['-g', "#{chars}:#{replace}"] }

        before { subject.option_parser.parse(argv) }

        it "must append to #modifiers" do
          expect(subject.modifiers.length).to be(1)
          expect(subject.modifiers[0][0]).to be(:gsub)
          expect(subject.modifiers[0][1].length).to be(2)
          expect(subject.modifiers[0][1][0]).to eq(chars)
          expect(subject.modifiers[0][1][1]).to eq(replace)
        end
      end

      context "when given --gsub CHARS:REPLACE" do
        let(:chars)   { 'e' }
        let(:replace) { '3' }
        let(:argv)    { ['--gsub', "#{chars}:#{replace}"] }

        before { subject.option_parser.parse(argv) }

        it "must append to #modifiers" do
          expect(subject.modifiers.length).to be(1)
          expect(subject.modifiers[0][0]).to be(:gsub)
          expect(subject.modifiers[0][1].length).to be(2)
          expect(subject.modifiers[0][1][0]).to eq(chars)
          expect(subject.modifiers[0][1][1]).to eq(replace)
        end
      end

      context "when given -m CHARS:REPLACE" do
        let(:chars)   { 'e' }
        let(:replace) { '3' }
        let(:argv)    { ['-m', "#{chars}:#{replace}"] }

        before { subject.option_parser.parse(argv) }

        it "must append to #modifiers" do
          expect(subject.modifiers.length).to be(1)
          expect(subject.modifiers[0][0]).to be(:mutate)
          expect(subject.modifiers[0][1].length).to be(2)
          expect(subject.modifiers[0][1][0]).to eq(chars)
          expect(subject.modifiers[0][1][1]).to eq(replace)
        end
      end

      context "when given --mutate CHARS:REPLACE" do
        let(:chars)   { 'e' }
        let(:replace) { '3' }
        let(:argv)    { ['--mutate', "#{chars}:#{replace}"] }

        before { subject.option_parser.parse(argv) }

        it "must append to #modifiers" do
          expect(subject.modifiers.length).to be(1)
          expect(subject.modifiers[0][0]).to be(:mutate)
          expect(subject.modifiers[0][1].length).to be(2)
          expect(subject.modifiers[0][1][0]).to eq(chars)
          expect(subject.modifiers[0][1][1]).to eq(replace)
        end
      end

      context "when given -M" do
        let(:argv) { ['-M'] }

        before { subject.option_parser.parse(argv) }

        it "must append to #modifiers" do
          expect(subject.modifiers.length).to be(1)
          expect(subject.modifiers[0][0]).to be(:mutate_case)
          expect(subject.modifiers[0][1].length).to be(0)
        end
      end

      context "when given --mutate CHARS:REPLACE" do
        let(:argv) { ['--mutate-case'] }

        before { subject.option_parser.parse(argv) }

        it "must append to #modifiers" do
          expect(subject.modifiers.length).to be(1)
          expect(subject.modifiers[0][0]).to be(:mutate_case)
          expect(subject.modifiers[0][1].length).to be(0)
        end
      end

      context "when given --build WORDLIST" do
        let(:wordlist) { File.join(fixtures_dir,'new_wordlist.txt') }
        let(:argv)     { ['--build', wordlist] }

        before { subject.option_parser.parse(argv) }

        it "must append to #modifiers" do
          expect(subject.mode).to eq(:build)
          expect(subject.output).to eq(wordlist)
        end
      end

      context "when given -V" do
        let(:argv) { ['-V'] }

        it "must append to #modifiers" do
          expect(subject).to receive(:exit)

          expect {
            subject.option_parser.parse(argv)
          }.to output("#{described_class::PROGRAM_NAME} #{Wordlist::VERSION}#{$/}").to_stdout
        end
      end

      context "when given --version" do
        let(:argv) { ['--version'] }

        it "must append to #modifiers" do
          expect(subject).to receive(:exit)

          expect {
            subject.option_parser.parse(argv)
          }.to output("#{described_class::PROGRAM_NAME} #{Wordlist::VERSION}#{$/}").to_stdout
        end
      end

      context "when given -h" do
        let(:argv) { ['-h'] }

        it "must append to #modifiers" do
          expect(subject).to receive(:exit)

          expect {
            subject.option_parser.parse(argv)
          }.to output("#{subject.option_parser}").to_stdout
        end
      end

      context "when given --help" do
        let(:argv) { ['--help'] }

        it "must append to #modifiers" do
          expect(subject).to receive(:exit)

          expect {
            subject.option_parser.parse(argv)
          }.to output("#{subject.option_parser}").to_stdout
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
      it "must read each word from the file and print it to stdout"

      context "when also given the --exec COMMAND option" do
        it "must execute the command with each word from the wordlist"
      end
    end

    context "when given the --build option" do
      context "and given multiple input files" do
        it "must build a new wordlist file based on the given files"
      end

      context "and given no input files" do
        it "must build a new wordlist file by reading stdin"
      end
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
