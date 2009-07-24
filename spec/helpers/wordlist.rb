def should_contain_words(path,expected)
  words = []

  File.open(path) do |file|
    file.each_line do |line|
      words << line.chomp
    end
  end

  words.sort.should == expected.sort
end
