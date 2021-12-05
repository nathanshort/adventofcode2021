#!/usr/bin/env ruby

require 'scanf'

gridp1 = Hash.new( 0 )
gridp2 = Hash.new( 0 )

ARGF.each_line do |line|
    x1,y1,x2,y2 = line.scanf("%d,%d -> %d,%d")
    xinc = x1 > x2 ? -1 : ( x1 == x2 ? 0 : 1 )
    yinc = y1 > y2 ? -1 : ( y1 == y2 ? 0 : 1 )
    distance = [ (x2-x1).abs, (y2-y1).abs ].max + 1
    distance.times do 
      point = "#{x1},#{y1}"
      gridp1[point]+=1 if ( x1 == x2 || y1 == y2 ) 
      gridp2[point]+=1
      x1 += xinc
      y1 += yinc 
    end
end

puts "part 1: #{gridp1.count { |_,intersections| intersections >= 2 }}"
puts "part 2: #{gridp2.count { |_,intersections| intersections >= 2 }}"