#!/usr/bin/env ruby

# given an input like [ 'abcefg', 'cf', 'acdeg', ...]
# build up map of frequencies per letter like: {"a"=>{6=>3, 5=>3, 3=>1, 7=>1}, ...
# meaning, segment 'a' shows up 3 times in numbers made from 6 segments, 3 times in numbers
# made from 5 segments, 1 time in numbers made from 3 segments, and 1 time in numbers
# made from 7 segments 
def freq_for( input )
  freqs = {}
  input.each do |i|
   i.chars.each do |c|
     freqs[c] ||= Hash.new(0) 
     freqs[c][i.length] += 1
   end
  end
 freqs
end

display = [ 'abcefg','cf','acdeg','acdfg','bcdf','abdfg','abdefg','acf','abcdefg','abcdfg' ]
actuals = freq_for( display )

part1count, part2sum = 0,0
ARGF.each_line do |line|
  input, output = line.chomp.split("|").map{ |x| x.scan(/\w+/)}
  observed = freq_for( input )
  decoder = {} # holds mapping of observed char to actual char
  observed.each do |oletter,ocounts|
    decoder[oletter] = actuals.select{ |_,acounts| ocounts == acounts }.keys.first
  end

  output.reverse.each_with_index do |output,oindex|
    actual = output.chars.inject(""){|memo,c| memo << decoder[c] }.chars.sort.join
    part2sum += display.index( actual ) * 10**oindex
  end

  part1count += output.count {|x| [2,4,3,7].include?( x.length ) }
end

puts "part1: #{part1count}"
puts "part2: #{part2sum}"