require 'spec_helper'
require 'wordlist/operators/binary_operator'

describe Wordlist::Operators::BinaryOperator do
  let(:left)  { %w[foo bar] }
  let(:right) { %w[baz qux] }

  subject { described_class.new(left,right) }

  describe "#initialize" do
    it "must set #left" do
      expect(subject.left).to eq(left)
    end

    it "must set #right" do
      expect(subject.right).to eq(right)
    end
  end
end
