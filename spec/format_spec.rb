require 'spec_helper'
require 'wordlist/format'

describe Wordlist::Format do
  describe ".infer" do
    context "when given a path ending in '.txt'" do
      it "must return :txt" do
        expect(subject.infer("path/to/file.txt")).to eq(:txt)
      end
    end

    context "when given a path ending in '.gz'" do
      it "must return :gzip" do
        expect(subject.infer("path/to/file.gz")).to eq(:gzip)
      end
    end

    context "when given a path ending in '.bz2'" do
      it "must return :bzip2" do
        expect(subject.infer("path/to/file.bz2")).to eq(:bzip2)
      end
    end

    context "when given a path ending in '.xz'" do
      it "must return :xz" do
        expect(subject.infer("path/to/file.xz")).to eq(:xz)
      end
    end

    context "when given a path ending in another file extension" do
      let(:path) { "path/to/file.foo" }

      it do
        expect {
          subject.infer(path)
        }.to raise_error(Wordlist::UnknownFormat,"could not infer the format of file: #{path.inspect}")
      end
    end
  end
end
