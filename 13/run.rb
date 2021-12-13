require_relative '../lib/common'
require 'scanf'

points, instructions = ARGF.read.split(/\n\n/)
grid = Grid.new
points.split(/\n/).each do |point|
  x,y = point.split(',')
  grid[Point.new(x.to_i,y.to_i)] = '#'
end

instructions.split(/\n/).each_with_index do |i,index|
    axis,fold_point = i.scanf( "fold along %c=%d" )
    resulting_grid = Grid.new
    grid.each do |point,_|
      y = axis == 'y' ? ( fold_point - ( point.y - fold_point ).abs ) : point.y
      x = axis == 'x' ? ( fold_point - ( point.x - fold_point ).abs ) : point.x
      resulting_grid[Point.new(x,y)] = '#'
    end
    grid = resulting_grid
    puts "part 1: #{grid.points.count}" if index == 0
end

grid.show

