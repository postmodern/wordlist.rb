require 'spec_helper'
require 'wordlist/lexer/lang'

describe Wordlist::Lexer::Lang do
  describe ".default" do
    subject { described_class }

    context "when LANG is set" do
      context "and is of the form xx" do
        let(:env) { {'LANG' => 'xx'} }

        before { stub_const('ENV', env) }

        it "must return xx as a Symbol" do
          expect(subject.default).to be(:xx)
        end
      end

      context "and is of the form xx_YY" do
        let(:env) { {'LANG' => 'xx_YY'} }

        before { stub_const('ENV', env) }

        it "must return xx as a Symbol" do
          expect(subject.default).to be(:xx)
        end
      end

      context "and is of the form xx_YY.UTF-8" do
        let(:env) { {'LANG' => 'xx_YY.UTF-8'} }

        before { stub_const('ENV', env) }

        it "must return xx as a Symbol" do
          expect(subject.default).to be(:xx)
        end
      end

      context "and is of the form C.UTF-8" do
        let(:env) { {'LANG' => 'C.UTF-8'} }

        before { stub_const('ENV', env) }

        it "must return :en" do
          expect(subject.default).to be(:en)
        end
      end
    end

    context "when LANG is C" do
      let(:env) { {'LANG' => 'C'} }

      before { stub_const('ENV', env) }

      it "must default to :en" do
        expect(subject.default).to be(:en)
      end
    end

    context "when LANG is not set" do
      let(:env) { {} }

      before { stub_const('ENV', env) }

      it "must default to :en" do
        expect(subject.default).to be(:en)
      end
    end
  end
end
