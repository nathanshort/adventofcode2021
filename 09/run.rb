require_relative '../lib/common'

# recursively climb out of a basin
def climb( grid, point, basin )
  if point.hvadjacent.all? {|adj| !grid[adj] || basin[point] || grid[adj].to_i > grid[point].to_i }
   basin[point] = true
   point.hvadjacent.each do |a|
     if grid[a] && ! basin[a] && grid[a].to_i != 9
      basin[a] = true
      climb( grid, a, basin ) 
     end
   end
  end
 basin
end

grid = Grid.new( :io => ARGF )
lowpoints = []
grid.each { |point, val| lowpoints << point if point.hvadjacent.all? {|adj| !grid[adj] || grid[adj].to_i > val.to_i } }
basins = lowpoints.map {|p| climb( grid, p, {} ) }

puts "part 1: #{lowpoints.map{ |p| grid[p].to_i + 1 }.sum}"
puts "part 2: #{basins.map {|b| b.keys.count }.sort.reverse[0,3].inject(:*)}"