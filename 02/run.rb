#!/usr/bin/env ruby

directions = ARGF.each_line.map {|x| v = x.split; [ v[0], v[1].to_i ] }

def part1( directions)
   l = {:hpos => 0, :depth => 0 }
    directions.each do |d|
     case d[0]
      when 'forward'
        l[:hpos] += d[1]
      when 'down'
        l[:depth] += d[1]
      when 'up'
        l[:depth] -= d[1]
     end
   end
 l
end

def part2( directions )
    l = {:hpos => 0, :depth => 0, :aim => 0 }
    directions.each do |d|
     case d[0]
     when 'forward'
       l[:hpos] += d[1]
       l[:depth] += l[:aim] * d[1]
     when 'down'
       l[:aim] += d[1]
     when 'up'
       l[:aim] -= d[1]
     end
    end
 l
end


l = part1( directions )
puts "part 1: #{l[:hpos] * l[:depth]}"

l = part2( directions )
puts "part 2: #{l[:hpos] * l[:depth]}"