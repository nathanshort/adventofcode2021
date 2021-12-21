require_relative '../lib/common'

algo,image = ARGF.read.split(/\n\n/).map(&:chomp)
grid = Grid.new( :io => image)
algo = algo.chars

def doit( p, resulting_grid, grid, inf, algo )
  lookup = {'.' => '0', '#' => '1' }

  number = [-1,0,1].repeated_permutation(2).sort.reduce("") do |memo,perm|
    yoff,xoff = perm
    memo + lookup[grid[Point.new(p.x+xoff,p.y+yoff)] || inf ]
  end.to_i(2)
  
  resulting_grid[p] = algo[number]
end

inf = '.'
50.times do |iter|
  resulting_grid = grid.dup
  grid.each{ |p,val| doit( p, resulting_grid, grid, inf,algo ) }
  grid.outside_points( 2, 2, 2, 2 ) { |p| doit( p, resulting_grid, grid, inf,algo ) }
  grid = resulting_grid

  # might not work for all inputs.  my input has algo.first going to # and algo.last going to .
  inf = ( inf == '.' ? '#' : '.')
end

puts grid.count{ |k,v| v == '#' }
