require 'date'
require_relative 'collection'

Pair = Struct.new(:fst,:snd)



def summingPairs(xs, sum)
    splitList =(xs.each_slice( (xs.size/2.0).round ).to_a)
    
    t1 = Thread.new {Thread.current[:output] = concurrentSummingPairHelper(splitList[0], splitList[0], sum)}
    t2 = Thread.new {Thread.current[:output] = concurrentSummingPairHelper(splitList[1], splitList[1], sum)}
    t3 = Thread.new {Thread.current[:output] = concurrentSummingPairHelperGreedy(splitList[0], splitList[1], sum)}
    t1.join
    t2.join
    t3.join
    
    return ( t1[:output]+t2[:output]+ t3[:output])
end

def concurrentSummingPairHelperGreedy(first_half, second_half, sum)
    the_pairs = []
    len = first_half.length
    len1 = second_half.length

    for i in 0..(len-1)
        for j in (0)..(len1-1)
        if first_half[i] + second_half[j] <= sum
            the_pairs.push(Pair.new(first_half[i],second_half[j]))
        end
        end
    end
    return the_pairs

end


def concurrentSummingPairHelper(first_half, second_half, sum)
    the_pairs = []
    len = first_half.length
    len1 = second_half.length

    for i in 0..(len-1)
        for j in (i+1)..(len1-1)
        if first_half[i] + second_half[j] <= sum
            the_pairs.push(Pair.new(first_half[i],second_half[j]))
        end
        end
    end
    return the_pairs

end



puts "Starting at:   #{DateTime.now.sec} seconds, #{DateTime.now.strftime("%9N")} nanoseconds"
puts summingPairs(INPUT,2020)
puts "Ending at:     #{DateTime.now.sec} seconds, #{DateTime.now.strftime("%9N")} nanoseconds"

