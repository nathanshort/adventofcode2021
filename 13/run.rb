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
      x,y = point.x,point.y
      point_to_fold = ( axis == 'y' ? y : x )
      point_to_fold = fold_point - ( point_to_fold - fold_point ).abs 
      y = ( axis == 'y' ? point_to_fold : y )
      x = ( axis == 'x' ? point_to_fold : x )
      resulting_grid[Point.new(x,y)] = '#'
    end
    grid = resulting_grid
    puts "part 1: #{grid.points.count}" if index == 0
end

grid.show

