
class D100

  attr_reader :total_rolls

  def initialize
    @d, @total_rolls = 0,0
  end

  def get(n)
    @total_rolls += n
    n.times.map{ @d = ( @d % 100 ) + 1 }
  end
end


def move( score, position, by )
  position = ( position + by % 10 )
  position = position % 10 if position > 10
  [ score+position, position ]
end


# returns both scores after someone wins
def part1( p1, p2, d )
  p1 = move( p1[0], p1[1], d.get(3).sum )
  return [p1[0],p2[0]] if p1[0] >= 1000
  return part1( p2, p1, d )
end


d = D100.new 
p1 = part1( [0,7], [0,1], d )
puts "part 1: #{p1.min * d.total_rolls}"


def part2( p1, p2, roll_sums, cache )

  return [1,0] if p1[0] >= 21
  return [0,1] if p2[0] >= 21
  cache_key = [p1,p2]
  return cache[cache_key] if cache.key?(cache_key)

  wins = [0,0]
  roll_sums.each do |rs|
    next_p1 = move( p1[0], p1[1], rs )
    this_win = part2( p2, next_p1, roll_sums, cache )
    wins = [wins[0]+this_win[1],wins[1]+this_win[0]]
  end

  cache[cache_key] = wins
end

roll_sums = [1,2,3].product([1,2,3], [1,2,3]).map(&:sum)
cache = {}
puts "part 2: #{part2( [0,7], [0,1], roll_sums, cache ).max}"
