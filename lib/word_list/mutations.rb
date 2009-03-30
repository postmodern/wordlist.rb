module WordList
  module Mutations
    def mutators
      @mutators ||= Hash.new { |hash,key| hash[key] = [] }
    end

    def mutator(pattern,substitutes)
      mutators[pattern] += substitutes
    end

    def each_mutation(word,&block)
      mutators.each do |pattern,substitutes|
        substitutes.each do |substitute|
          block.call(pattern.sub(pattern,substitute))
        end
      end
    end

    def print_mutators(out=STDOUT)
      mutators.each do |pattern,substitutes|
        out.puts "#{pattern.inspect} => #{substitues.inspect}"
      end
    end
  end
end
