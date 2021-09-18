require 'spec_helper'
require 'wordlist/gzip'

describe Wordlist::GZip do
  let(:fixtures_dir) { File.join(__dir__,'fixtures') }
  let(:path) { File.join(fixtures_dir,'wordlist.txt.gz') }

  subject { described_class.new(path) }

  describe "#each_line" do
    let(:expected_lines) { `zcat #{Shellwords.shellescape(path)}`.lines }

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
