require_relative '../lib/common'

grid = Grid.new( :io => ARGF ) {|x,y,c| [x,y,c.to_i] }

# returns the count of number of flashers this iteration
def run( grid )
    flashers = []  
    grid.each do |point,val|
      grid[point] += 1 
      flashers << point if grid[point] > 9 
    end
   
    seen = {}
    while flasher = flashers.pop
      next if seen[flasher]
      seen[flasher] = true
      flasher.adjacent.each do |neighbor|
        if val = grid[neighbor] 
          grid[neighbor] += 1
          flashers << neighbor if grid[neighbor] > 9
        end
      end
    end
  
     seen.each { |p,_| grid[p] = 0 }
     seen.keys.count
end

puts "part 1: #{100.times.reduce(0){ |memo,_| memo + run(grid)}}"

count = 101 #we just did 100 iterations. now start at 101 till we hit all flashers
count += 1 while run(grid) != 100
puts "part 2: #{count}" 


