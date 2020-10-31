# part 1

def fizzbuzzLooper(l)
    array = []
    l.each do |element|
        # a = element % 2 == 0
        if element % 3 == 0 && element % 5 == 0  
            array << "fizzbuzz"
        elsif element % 3 == 0 
            array << "fizz"
        elsif element % 5 == 0 
            array << "buzz"
        else
            array << element.to_s
        end
    end
    array
end
fizzbuzzLooper([0,10,9,1,2])

# part 2
def fizzbuzzIterator(l)
    array = []
    l.each do |element|
        # a = element % 2 == 0
        if element % 3 == 0 && element % 5 == 0  
            array << "fizzbuzz"
        elsif element % 3 == 0 
            array << "fizz"
        elsif element % 5 == 0 
            array << "buzz"
        else
            array << element.to_s
        end
    end
    array
end

# part3
def zuzzer(l,rules)
    array =[]
    l.each do |elem|
        str = ""
        rules.each do |r|
            if r[0].call(elem)
                str =  str + r[1].call(elem)
            end
        end
        if str == ""
            str = elem.to_s
        end
        array << str
    end
    array
end
