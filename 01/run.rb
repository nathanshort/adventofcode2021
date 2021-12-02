#!/usr/bin/env ruby

data = ARGF.each_line.map { |line| line.to_i }

count = data.each_cons(2).count {|e| e[0] < e[1] }
puts "part 1: #{count}"
    
count = data.each_cons(3).map{ |x| x.inject(:+) }.each_cons(2).count {|e| e[0] < e[1] }
puts "part 2: #{count}"