#!/usr/bin/env/ruby

def distance_from( data, target )
  data.reduce(0) { |sum,d| sum + ( d-target).abs }
end

def distance_from2( data, target )
    sum = 0 
    data.each {|d| (d-target).abs.times {|d| sum+= ( d+1 )}}
    sum
 end        

# less iterations than just brute forcing between data.min and data.max, 
# walk down from the avg till the distance stops decreasing
# then do the same walking up
def doit( data, aggregator )
  average =  ( data.sum  / data.count )
  prev_distance = 10000000000
  average.downto(0) do |target|
   d = aggregator.call( data, target )
   break unless d < prev_distance
   prev_distance = d
  end

  min = prev_distance
  prev_distance = 10000000000
  ( ( average+1) .. ( average+data.max)).each do |target|
    d = aggregator.call( data, target )
    break unless d < prev_distance
    prev_distance = d
    min = d if d < min
 end
 min
end

data = ARGF.read.split(",").map(&:to_i)

puts "part 1: #{doit( data, lambda{ |data, target | distance_from(data, target) } )}"
puts "part 2: #{doit( data, lambda{ |data, target | distance_from2(data, target) } )}"
