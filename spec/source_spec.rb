require 'wordlist/source'

require 'spec_helper'
require 'classes/test_source'

describe Source do
  before(:all) do
    @source = TestSource.new
    @source.mutate /o/, 'O'
    @source.mutate /l/, '1'
  end

  it "should iterate over each word" do
    words = []

    @source.each_word { |word| words << word }

    words.should == ['lolol']
  end

  it "should iterate over each unique word" do
    words = []

    @source.each_unique { |word| words << word }

    words.should == ['lolol']
  end

  it "should iterate over every possible mutated word" do
    mutations = %w{
      lO1O1
      1OlO1
      lOlO1
      1O1Ol
      lO1Ol
      1OlOl
      lOlOl
      1o1O1
      lo1O1
      1olO1
      lolO1
      1o1Ol
      lo1Ol
      1olOl
      lolOl
      1O1o1
      lO1o1
      1Olo1
      lOlo1
      1O1ol
      lO1ol
      1Olol
      lOlol
      1o1o1
      lo1o1
      1olo1
      lolo1
      1o1ol
      lo1ol
      1olol
      lolol
    }

    @source.each_mutation do |mutation|
      mutations.include?(mutation).should == true
      mutations.delete(mutation)
    end

    mutations.should == []
  end
end
