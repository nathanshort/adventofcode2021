#!/usr/bin/env ruby

def get_mcb_lcb( data, position )
    ones = data.select {|d| ( d & ( 1 << position ) != 0 ) }.length
    zeros = data.length - ones
    if ones > zeros
        return [ 1, 0 ]
    elsif ones < zeros
        return [ 0, 1 ]
    else
        # sentinal for a tie
        return [ -1, nil ]
    end
end

def part2( data, str_length, tie_goes_to, mcb_mode )
    ( str_length - 1 ).downto(0) do |pos|
        mcb, lcb = get_mcb_lcb( data, pos )
        target = ( mcb == -1 ? tie_goes_to : ( mcb_mode ? mcb : lcb ) )
        if target == 1
           data = data.select {|d| d & ( 1 << pos ) != 0 }
        else
           data = data.select {|d| d & ( 1 << pos ) == 0 }
        end
        if data.length == 1
           break
        end
      end
   data[0]
end

data = ARGF.each_line.map {|line| line.chomp.to_i(2) }

# this is the string length of each diagnostic entry.  
str_length = 12

gamma, epsilon = 0,0
str_length.times do |pos|
   # the problem doesnt define what happens if there are equal
   # set bit counts for part 1, so, assume that there arent
   mcb,_ = get_mcb_lcb( data, pos )
   gamma |= ( 1 << pos ) if mcb == 1
   epsilon |= ( 1 << pos ) if mcb == 0
end
puts "part 1: #{gamma * epsilon}"

oxygen = part2( data, str_length, tie_goes_to = 1, mcb_mode = true )
co2 = part2( data, str_length, tie_goes_to = 0, mcb_mode = false )
puts "part 2: #{oxygen * co2 }"



