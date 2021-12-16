require_relative '../lib/common'
require_relative '../lib/pqueue'

def find_path( grid )

  visited, distances, prev = {},{},{}
  pq = PQueue.new {|x,y| distances[x] < distances[y] }
  origin = Point.new(0,0)
  pq.push(origin)
  visited[origin] = true
  distances[origin] = 0

  while ! pq.empty?
    current = pq.pop
    visited[current] = true

    current.hvadjacent.each do |a|
      next if ! grid[a] || visited.key?(a)
      distance = grid[a] + distances[current] 
      if ! distances.key?(a) || distances[a] > distance
        distances[a] = distance
        prev[a] = current
        pq.push(a)
      end
    end
  end

  target = Point.new(grid.width-1,grid.height-1)
  risk = grid[target]
  pprev = prev[target]
  while pprev != origin
   risk += grid[pprev]
   pprev = prev[pprev]
  end 

 risk 
end

grid = Grid.new( :io => ARGF ) {|x,y,c| [x,y,c.to_i] }
puts "part 1:#{find_path( grid )}"

originalg = grid.dup
5.times do |x|
    xoffset = x * originalg.width
    5.times do |y|
      next if y == 0 && x == 0 
      yoffset = y * originalg.height
      originalg.each { |p,val| grid[Point.new(p.x+xoffset,p.y+yoffset)] = (val+x+y)/10 + (val+x+y)%10 }
   end
end

puts "part 2:#{find_path( grid )}"

