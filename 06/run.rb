#!/usr/bin/env ruby

def doit( data, iterations )
    counts = Array.new( size = 9, start = 0)
    data.each {|d| counts[d] += 1 }
    iterations.times do
        counts[7] += counts[0]
        counts.rotate!
    end
    counts.sum
end

data = ARGF.read.split(',').map( &:to_i )

puts "part 1: #{ doit( data, 80 )}"
puts "part 2: #{ doit( data, 256 )}"
