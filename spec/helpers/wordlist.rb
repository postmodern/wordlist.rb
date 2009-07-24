def should_be_unique(path)
  words = []

  File.open(path) do |file|
    file.each_line do |line|
      words << line.chomp
    end
  end

  words.should == words.uniq
end
