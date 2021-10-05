require 'spec_helper'
require 'wordlist/bzip2'

describe Wordlist::BZip2 do
  let(:fixtures_dir) { File.join(__dir__,'fixtures') }
  let(:path) { File.join(fixtures_dir,'wordlist.txt.bz2') }

  subject { described_class.new(path) }

  describe ".command" do
    subject { described_class }

    it { expect(subject.command).to eq("bzcat") }
  end

  describe "#command" do
    it "must return the 'zcat' and the wordlist path" do
      expect(subject.command).to eq("bzcat #{Shellwords.shellescape(path)}")
    end
  end

  describe "#each_line" do
    let(:expected_lines) { `bzcat #{Shellwords.shellescape(path)}`.lines }

    context "when given a block" do
      it "must yield each read line of the file" do
        expect { |b|
          subject.each_line(&b)
        }.to yield_successive_args(*expected_lines)
      end
    end

    context "when not given a block" do
      it "must return an Enumerator" do
        expect(subject.each_line).to be_kind_of(Enumerator)
        expect(subject.each_line.to_a).to eq(expected_lines)
      end
    end
  end
end
